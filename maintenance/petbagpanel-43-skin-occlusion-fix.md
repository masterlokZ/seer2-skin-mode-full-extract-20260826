# 精灵背包（PetBagPanel）43 版皮肤模型遮挡适配

> 2026-09-22 修复。43 版官方大更新后，精灵皮肤模型体积变大，遮挡了底部按钮。修复目标：模型不拦截鼠标，其余行为完全保持 43 原版。

## 背景

43 版是官方大更新：布局体系重构、新增 7 个类、时间轴符号重排、技能点选交互改进。用户实测确认：

- 纯 43 原版 PetBagPanel.swf（SHA256 `22AE38E35871F3F71F43C74AD11A87EDADE8C6D2DA498D0E13D5FD0C1F0ED17B`，191635 字节）运行正常，技能替换、切换精灵全部 OK
- 但大皮肤模型（如孙悟空、约瑟王）遮挡了底部按钮，导致无法点击

## 修复目标

1. 皮肤模型不拦截鼠标——点击穿透模型到下方按钮
2. 技能调整 tab、技能替换、切换精灵等所有功能与 43 原版完全一致
3. 零额外副作用

## 修改内容

仅修改一个类 `com.taomee.seer2.module.app.versionOnePetBagPanel.PetDemoPanel`，**仅 2 行**：

```actionscript
// 原始 43：
this._petDemoDisplayer.mouseEnabled = true;

// 改为：
this._petDemoDisplayer.mouseEnabled = false;
this._petDemoDisplayer.mouseChildren = false;
```

零 re-parent、零 swapChildren、零循环置顶、零控件名单、零 trace。显示层级完全保持 43 原版。

## 构建方式

**FFDec `-importScript` 定向单类替换**（详见 [swf-pipeline-rules.md](./swf-pipeline-rules.md)）：

```bash
# 步骤 1：从原始 43 SWF 导出全部 AS3 源码
java -Xmx8g -jar ffdec.jar -onerror abort -export script ./export latest43-PetBagPanel.swf

# 步骤 2：修改 PetDemoPanel.as 2 行（见上文）

# 步骤 3：把修改后的 PetDemoPanel.as 按完整包路径放入文件夹
mkdir -p scripts/com/taomee/seer2/module/app/versionOnePetBagPanel/
cp PetDemoPanel.as scripts/com/taomee/seer2/module/app/versionOnePetBagPanel/

# 步骤 4：导回原始 43 SWF（只替换 PetDemoPanel 一个类）
java -Xmx8g -jar ffdec.jar -onerror abort -importScript latest43-PetBagPanel.swf PetBagPanel-v5.swf ./scripts
```

其余 66 个类字节码保持官方原始值一字不动。

## 最终产物

| 属性 | 值 |
|------|-----|
| SHA256 | `B133431FB17837FF62EC2616532421EC342A5F86EF81E6E13469CF0CBF611D58` |
| 大小 | 184831 字节（原始 43 为 191635 字节，差 6804 字节仅来自 PetDemoPanel 单类 ABC 体积变化） |
| 修改类数 | 1（PetDemoPanel） |
| 零改动类数 | 66（字节码与原始 43 逐字节一致） |

## 验证结果（用户实测通过）

- ✅ 大皮肤模型下底部按钮可点
- ✅ 技能调整 tab 正常显示
- ✅ 技能替换正常
- ✅ 切换精灵后技能替换正常
- ✅ 模型仍可见（只是不拦截鼠标）

## 废弃版本（全部备份在 docs/petbag-two-fix-20260922/）

| 版本 | 构建方式 | SHA256 | 症状 |
|------|----------|--------|------|
| v1 | 全类重编译 + re-parent + 循环置顶 | 838867B0...9DE33F | 点击技能替换卡死 |
| v2 | 全类重编译 + swapChildren | A0F4116E...0467C0C | 更诡异的行为 |
| v3 | 全类重编译 + 旧遮挡写法移植 | 0DD97A92...57F18F5 | 技能面板消失 |
| v4 | 全类重编译 + 仅禁鼠标 | E0509DA0...BAD7 | 技能调整 tab 不见 |

所有 v1-v4 都是全类重编译产物，67 个类全部被 FFDec 反编译+Flex 重编译，编译噪音累积导致运行时失败。**v5 是唯一用 FFDec 定向单类替换的版本，也是唯一通过实测的版本。**

## 相关文档

- [swf-pipeline-rules.md](./swf-pipeline-rules.md) — 全类重编译 vs FFDec 定向替换的完整法则
- [PetDemoPanel.as](../PetBagPanel/full-extract/scripts/com/taomee/seer2/module/app/versionOnePetBagPanel/PetDemoPanel.as) — 修改后的源码
- [PetBagPanel.v5.swf](../PetBagPanel/final/PetBagPanel.v5.swf) — 最终产物
