# PetDictionary：43 上游更新后的皮肤模式适配清单

本文记录皮肤模式 `PetDictionary.swf` 相对 43 最新官方版本需要重复保留的最小改动。以后上游更新时，先核对结构；结构相同或仅有普通代码增量时，按本文重新移入适配。若类、方法、时间轴或数据合同发生变化，停止机械复用，重新设计。

本文不是旧源码覆盖说明。禁止把旧版整个 `PetDictionaryDataServer`、`NewPetDicsListCell` 或整份 ABC 直接盖到新版上，否则会丢失上游新增精灵、筛选和 UI 逻辑。

## 当前已验证版本

| 项目 | 值 |
|---|---|
| 43 基底 | `PetDictionary.swf`，183009 字节 |
| 43 基底 SHA-256 | `A926CEC965BEC85917F5CF62D17E62616AA3807F3C21C546CF3BC59A288414FE` |
| 正式适配版 SHA-256 | `D30C4D4FE15872F8EFB18E27556FB1B84B170678D9AF00A3573735F193EAF378` |
| 正式适配版大小 | 182586 字节 |
| ABC 合并 | 原文件唯一 `DoABC2Tag`，名称 `merged` |
| 时间轴门禁 | 418 个顶层标签；除 1 个 ABC 外，417 个原始标签逐字节不变 |
| 编译组合 | Flex SDK 4.16.1，`target-player=27.0`，`swf-version=38` |

当前证据位于正式运行树：

- `D:/seer2-x32-hotfix/docs/petdictionary-avatar-merge-20260922/`
- `D:/seer2-panel-fourway-extract-20260922/`

## 必须保持的上游行为

新版基底的下列内容必须原样保留，不能用历史皮肤版实现替换：

1. `PetDictionaryDataServer.getAllPets()`：按 `1..PetConfig.getPetCount()` 枚举，且只收录 `< 9999`、同时存在定义和图鉴信息的条目。
2. `getAllSkins()`：按 `10000..PetConfig.getPetCount()` 枚举。
3. `getGainedPets()`、`getNotGainedPets()`、`getPetsByLevel()`：保持该次上游版本的循环、筛选和奖励语义。
4. `PetDictionary.as` 的最新页签、搜索、每周精灵、皮肤列表和奖励逻辑。
5. 43 原始时间轴、美术、按钮、符号 ID、帧脚本与导出类。

回读门禁：适配版 `PetDictionaryDataServer.as` 中不得重新出现历史方案的 `getPetDefinitionResourceIds` 枚举替代。

图鉴中有哪些精灵由 `PetConfig` 的当前 45/64 XML 和上游枚举共同决定。`PetDictionaryConfig__xmlClass` 主要负责图鉴奖励，不是精灵身份全集。

## 重复移入的三处适配

### 1. `PetDictionaryDataServer.as`：启动器路由桥

在新版类上保留其原有服务器协议、奖励和枚举逻辑，仅增加启动器皮肤路由职责。

需要增加的状态与生命周期：

- `URLLoader` 请求 `ClientConfig.rootURL + "launcher/custom-skin-routes.xml?time=" + new Date().time`；
- 监听完成、IO 错误、安全错误，并设置 3000ms 超时；
- 路由字段：`sourceId`、`officialIdOverride`、`fight`、`normal`、`demo`、`icon`、`presentation`、`iconPresentation`；
- 服务器图鉴数据与启动器路由必须都 settled 后，才调用 `_onGetGiftStatus`、`_onGetPetDictionary`、`_onGetRewardStatus`；
- 每次打开图鉴都清理旧 loader、旧 handler、旧 timeout 和旧 route map，使用 serial 防止旧异步结果污染新实例。

需要保留的身份和 URL 方法：

- `resolveResourceIdentity`；
- `getNormalizedResourceRole`、`getNormalizedBaseResourceId`、`isSkinResource`；
- `usesExternalModelIcon`、`usesFightSnapshotIcon`；
- `getPetIconUrl`、`isOfficialIdOverride`；
- `getPetAvatarFallbackModelUrl`；
- `getPetDemoUrl`；
- `hasLauncherRoute`、`getLauncherResourceUrl`。

身份语义：

- `Foundin="启动器本地导入"` 或 `chara="自定义资源"`：启动器外部皮肤；
- `realId > 0` 且本体定义存在：官方皮肤；
- 其他正常定义：本体；
- 历史 `10000` 分段形态只作已验证范围内的兼容身份，不得扩大成全数段推断。

### 2. `NewPetDicsListCell.as`：列表头像适配

普通官方头像继续走 `IconDisplayer`。只有启动器外部皮肤才进入模型头像链。

必须保留的结构：

- 读取 `iconHolder.width/height` 作为目标尺寸；
- `_modelIconLayer`：`mouseEnabled=false`、`mouseChildren=false`；
- `_iconMask` 覆盖整个头像槽位；外部模型层必须应用该 mask；
- serial 守卫，旧加载回调不能覆盖新条目；
- `clear()` 时取消请求、移除帧监听、释放 `BitmapData` 和模型引用。

加载顺序：

1. 独立 `icon` 路由可用时优先；
2. U 端没有独立头像或声明 fight-derived 时，用 `fight`；
3. 必要时回退 `normal` 或 `demo`；
4. loader 类型先尝试 `phasor`，失败时再尝试 `pet`；
5. 动画模型等待至少 2 帧且 bounds 有效，最长等待 30 帧，然后冻结子时间轴并生成头像。

尺寸和裁剪：

- 所有图像必须 `scaleX == scaleY`；
- 普通模型使用 `min(targetWidth / bounds.width, targetHeight / bounds.height)` 等比 fit；
- fight-derived/U 端模型使用 `snapshotPortraitModelIcon`：先按 alpha 像素扫描有效区域，再选择头像区域；
- 最终绘制到目标大小的透明 `BitmapData`，居中放进 `_modelIconLayer`；
- 失败时显式尝试 fallback，不允许把原始大模型直接挂到列表容器。

当前回归样本：

- `70091`、`70092`：没有独立头像，使用本地 `fight.swf` 自动生成头像；
- `70093`：有独立 `icon.swf`，必须限制在自己的头像格内，不能覆盖分页区或详情区。

### 3. `NewPetDicsPetDetailPanel.as`：右侧模型展示边界

只增加显示边界与本地路由，不改上游详情文本、属性、按钮行为。

固定逻辑：

- `_petDemoDisplayer.mouseEnabled = false`；
- `_petDemoDisplayer.mouseChildren = false`；
- 新建 `_petDemoMask:Sprite`；
- 遮罩矩形保持 `drawRect(-1, -22, 229, 253)`；
- `this._petDemoDisplayer.mask = this._petDemoMask`；
- 从原 UI 移出 `goBtn`、`changPetBtn` 后重新 `addChild`，确保按钮在模型和遮罩之上；
- `changePetDemo()` 使用 `PetDictionaryDataServer.getPetDemoUrl(this._currResId)`，不能直接调用 `URLUtil.getPetOriginDemo`。

该遮罩只限制展示内容，不应拉伸模型、改变详情面板坐标或修改 43 时间轴。

## 上游更新后的复用步骤

1. 从 43 重新下载最新 `PetDictionary.swf`，记录 SHA-256。
2. 对新文件执行 fresh `-exportembed -export all` 和 `-swf2xml`，不要复用旧提取目录。
3. 核对以下结构：
   - 仍只有一个待替换的 `DoABC2Tag`；
   - 仍存在上述三个类；
   - `PetDictionaryDataServer` 仍有服务器加载、五组列表方法及奖励方法；
   - `NewPetDicsListCellUI` 仍有 `iconHolder/isGained/isNew/isOpen/petNumber/petName`；
   - `NewPetDicsPetDetailPanel` 仍有 `goBtn/changPetBtn` 及 `PetDemoDisplayer`。
4. 若类名、控件名、方法签名、ABC 数量或时间轴结构不一致，立即停止复用，重新分析新版。
5. 结构兼容时，在新版源码中只重新加入本文三处适配；禁止整类复制旧文件后覆盖新版业务。
6. 使用完整新版提取源码配合 Flex `compc`、`mxmlc` 生成 donor。
7. donor ABC 名称改为原文件实际名称，再用 `Merge-DoABC.ps1` 单 ABC 合并。
8. 为保证二进制时间轴不被 FFDec XML 重编码，最终从编译候选提取 ABC 原始 tag，移入上游原始 SWF；逐标签断言所有非 ABC 原始字节一致。
9. 再次 FFDec 回读最终 SWF，检查本文的代码标记与上游枚举标记。

## 必须通过的验收

静态门禁：

- Flex 编译退出码 0；
- 单个 `merged` ABC；
- 非 ABC 标签数、类型、顺序和原始字节不变；
- 回读包含路由 manifest、外部身份、头像 fallback、透明区域肖像裁剪、等比 fit、mask、详情 `getPetDemoUrl`；
- 回读仍包含新版官方枚举，且无历史枚举替代；
- 正式 `custom-skins.json` 中的启用条目，其 icon/fight/normal 物理源文件存在。

正式登录器实测：

- 皮肤模式关闭时，图鉴精灵内容与 43 最新版一致；
- 开启皮肤模式后，上游本体列表不退化，本地皮肤进入“皮肤列表”；
- `70091/70092` 自动头像可见；
- `70093` 独立头像不越出头像格；
- 快速翻页、搜索、反复打开图鉴时无旧回调串项；
- 右侧详情模型不越出边框，GO/变身按钮可点击；
- 关闭皮肤模式后重新加载，不残留本地皮肤投影。

## 失败边界与回滚

- 任何初始化错误、VerifyError、面板打不开、头像越界、模型遮挡按钮或上游条目减少，均视为失败；
- 不通过时只恢复 `local-res/skin-mode/PetDictionary.swf`；
- 可从 `rollback-snapshots/2026-09-22-formal-runtime/PetDictionary.swf` 快速恢复历史五件套快照；
- 未经用户实测确认，不更新仓库 `PetDictionary/input/PetDictionary.swf`，不重打安装包。
