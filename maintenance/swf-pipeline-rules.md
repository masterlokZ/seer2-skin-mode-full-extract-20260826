# Flash SWF 热修补丁管线法则：全类重编译 vs FFDec 定向单类替换

> 精灵背包修复（2026-09-22）中绕了 4 个版本弯路才确认的核心教训。**小改动绝不走全类重编译**，这是不可妥协的黄金法则。

## 问题场景

需要对一个已编译的 Flash SWF 做微小修改（比如改 1~2 行 ActionScript），让修改后的 SWF 在运行时表现符合预期。

## 两条路线

### 路线 A：全类重编译（compc → mxmlc → Merge-DoABC）

```
原始 SWF
  → FFDec 导出全部 AS3 源码
  → 用 Flex compc/mxmlc 重新编译所有类
  → Merge-DoABC 把重编译后的 DoABC tag 替换回原始 SWF
  → 产出
```

**本次实战结果**：67 个类的 PetBagPanel，只想改 PetDemoPanel 一个类 2 行，产物大小从 191635 字节掉到 ~173K——**差了 18KB 意味着所有 67 个类都被重编译过**。症状：

- v1：卡死
- v2：诡异行为
- v3：技能面板消失
- v4：技能调整 tab 不见

**根因**：FFDec 反编译出来的源码有微妙噪音（变量名变化、类型推断缺失、闭包包装差异），Flex mxmlc 重编译后的字节码和官方编译器产物**不完全一样**。67 个类全部重编译时，这些差异累积，导致类间调用链断裂。症状各异但本质相同。

### 路线 B：FFDec 定向单类替换（ffdec -importScript）

```
原始 SWF
  → FFDec -export script 导出全部 AS3 源码（仅作参考）
  → 修改目标类的 AS3 源码
  → 在一个空文件夹里，按完整包路径放入修改后的单文件
  → FFDec -importScript 把该文件夹导回原始 SWF
  → 产出（仅被修改的那一个类的 ABC 被替换，其余类字节码保持原始值一字不动）
```

**本次实战结果**：PetDemoPanel 改 2 行，产物 184831 字节（原始 191635，差 6804 字节——正好是 PetDemoPanel 一个类的 ABC 被 FFDec 编译后的体积变化）。其余 66 个类字节码与原始 SWF 逐字节一致。**用户实测全部通过。**

## 决策矩阵

| 改动规模 | 推荐路线 | 原因 |
|----------|----------|------|
| 1~5 个类，小改动 | **FFDec -importScript 定向替换** | 其余类保持原始字节码，零编译噪音 |
| 1~5 个类，中等改动 | **FFDec -importScript 定向替换** | 同上，改完先跑 known-good baseline 验证 |
| 5~20 个类 | FFDec 定向替换（逐个或分批） | 每批替换后验证 |
| 20+ 个类大规模重构 | 全类重编译 + Merge-DoABC | 此时定向替换反而繁琐，但**必须建立完整运行时测试覆盖**再做 |

## FFDec -importScript 操作要点

1. **文件夹结构必须匹配完整包路径**。例如要替换 `com.taomee.seer2.module.app.versionOnePetBagPanel.PetDemoPanel`，脚本文件夹必须是：

   ```
   scripts/
     com/taomee/seer2/module/app/versionOnePetBagPanel/PetDemoPanel.as
   ```

   不能只放 `scripts/PetDemoPanel.as`——FFDec 找不到，会跳过或报错。

2. **只放要替换的类**。文件夹里只有被修改的那一个 `.as` 文件，其他类不要放。`-importScript` 只会替换文件夹里存在的类，不存在的保持原样。

3. **命令格式**：

   ```bash
   java -Xmx8g -jar ffdec.jar -onerror abort -importScript <input.swf> <output.swf> <scripts-folder>
   ```

4. **改回原始 SWF**。`-importScript` 的输入必须是原始未修改的 SWF，不能是之前重编译过的产物——否则之前的编译噪音会被继承。

5. **改前先 export 原始源码**。用 `-export script` 从原始 SWF 导出 AS3，在导出的文件上修改——不要手写或从其他来源复制。FFDec 导出的源码是原始字节码的直接反编译，改它最安全。

## 黄金法则

1. **小改动用 FFDec 定向单类替换，绝不用全类重编译。**
2. **纯原版二进制验证必须作为第一步建立 known-good baseline。** 先部署原始 SWF 让用户确认功能正常，再叠加改动。
3. **每次只改 1 行逐步叠加。** 不要多行改动一起上——出问题时无法定位是哪行引入的。
4. **构建路径上任何可疑的"捷径"都可能引入编译噪音。** Merge-DoABC 看起来比 importScript 快，但代价是全部类被重编译。
5. **SWF 大小变化本身就是信号。** 原始 191635 → 定向替换 184831（差 6.8KB = 一个类）→ 全类重编译 ~173K（差 18KB = 所有类）。看到产物大小掉了几十 KB 就要警觉。

## 精灵背包实战验证

- 原始 43 SWF：191635 字节，known-good
- importScript 定向替换 PetDemoPanel 2 行：184831 字节，✅ 全部正常
- 全类重编译（同样改 PetDemoPanel 2 行）：~173K 字节，❌ 技能调整 tab 消失

**两条路线，同样 2 行改动，产物大小差 11KB，运行时表现天差地别。**
