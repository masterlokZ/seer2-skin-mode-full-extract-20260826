# Seer2 皮肤模式五件套全量提取（已清理）

本目录保存正式五件套的全量提取结果。CoreDLL 的 `SetupAfterFreshTask` 已使用干净原始 ABC 整块替换并重建，移除了历史自定义工具常量池；正常游戏协议类（包括原生 Parser_1521）未删除。

每个文件夹包含 `input/`、`decrypted/`、`full-extract/`、`scripts/`、`pcode/`、`document.xml` 与 `tags.txt`。CoreDLL 的 `input/` 是加密文件，`decrypted/` 是对应明文。