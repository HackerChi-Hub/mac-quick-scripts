# Mac Quick Scripts

> Mac 一键工具脚本集 —— 用最简单的方式解决那些「苹果不给你解决」的小烦恼。

## 🎮 game-res — 刘海屏游戏模式一键切换

### 痛点

MacBook Pro 14/16 寸的刘海屏，玩游戏全屏时**画面被刘海挡住一块**——敌人可能就藏在那个黑黑的刘海后面，你根本看不见。

苹果原生的解决方案？没有。系统设置里要点好几层才能切到一个「避刘海」的分辨率，玩完还得切回去，烦死人。

### 效果

```bash
$ game-on
✓ 已切换到 游戏模式 (避刘海)  1512x945 (原 1512x982)
  ✓ 热区已关闭 (游戏防误触)

$ game-off
✓ 已切换到 默认模式  1512x982 (原 1512x945)
  ✓ 热区已恢复
```

两条命令，搞定。

### 它做了什么

| 命令 | 分辨率 | 热区 | 用途 |
|------|--------|------|------|
| `game-on` | 1512×945（避刘海） | 关闭（防误触） | 玩游戏前 |
| `game-off` | 1512×982（默认） | 恢复 | 玩完之后 |
| `game-res` | 显示当前状态 | — | 忘了的时候 |

- **避刘海**：切到 1512×945（比默认矮 37px，正好是刘海高度），整个工作区下移，刘海区域变成统一黑条，游戏画面完整不被挡。
- **关热区**：玩游戏时鼠标狂甩，很容易误触四个角落的热区（调度中心、桌面、通知中心、启动台），游戏模式下全部关闭，玩完恢复。
- **幂等**：重复执行不会重复切换，不会让 Dock 闪烁。

## 📦 安装

### 方式一：一键安装（推荐）

```bash
git clone https://github.com/HackerChi-Hub/mac-quick-scripts.git
cd mac-quick-scripts
./install.sh
```

安装脚本会自动：
1. 检查并安装依赖 `displayplacer`（via Homebrew）
2. 复制 `game-res` 到 `~/.local/bin/`
3. 创建 `game-on` / `game-off` 符号链接
4. 确认 `~/.local/bin` 在你的 PATH 里

### 方式二：手动安装

```bash
# 1. 装依赖
brew install displayplacer

# 2. 下载脚本
curl -o ~/.local/bin/game-res https://raw.githubusercontent.com/HackerChi-Hub/mac-quick-scripts/main/scripts/game-res
chmod +x ~/.local/bin/game-res

# 3. 建符号链接
ln -sf game-res ~/.local/bin/game-on
ln -sf game-res ~/.local/bin/game-off
```

### 前置要求

- MacBook Pro 14/16 寸（刘海屏机型）
- macOS Ventura 或更高
- [Homebrew](https://brew.sh/)

## 🎯 使用

```bash
game-on     # 玩游戏前：避刘海 + 关热区
game-off    # 玩完后：恢复默认 + 开热区
game-res    # 查看当前状态
```

### 自定义分辨率

不同型号的 Mac「避刘海分辨率」可能不同。编辑脚本顶部的配置：

```bash
vim ~/.local/bin/game-res
```

```bash
GAME_RES="1512x945"        # 避刘海分辨率 (改这里)
DEFAULT_RES="1512x982"     # 默认分辨率 (改这里)
```

查看你的机器支持哪些分辨率：

```bash
displayplacer list
```

### 自定义热区配置

如果你原本的热区设置和脚本里不一样，修改 `hotcorners` 函数里的值：

```bash
# 角落动作值: 1=无, 2=调度中心, 4=桌面, 12=通知中心, 14=启动台
# 顺序: 左上 右上 左下 右下
tl=2; tr=12; bl=4; br=14   # 这是 hc-on 恢复的值
```

## 🔧 技术细节

- **displayplacer**：开源命令行分辨率切换工具，比 AppleScript 操控系统设置稳定 100 倍。
- **自动识别屏幕**：通过 `displayplacer list` 动态获取内置屏 ID，不硬编码，换机也能用。
- **符号链接设计**：`game-on` 和 `game-off` 都是指向 `game-res` 的软链，脚本通过 `$0` 判断调用者，一份代码两个入口。
- **幂等检测**：执行前先读当前分辨率和热区状态，已是目标就跳过，避免无谓的屏幕闪烁。

## 📋 兼容性

| 机型 | 支持 | 备注 |
|------|------|------|
| MacBook Pro 14" (2021+) | ✅ | 默认分辨率 1512×982 |
| MacBook Pro 16" (2021+) | ✅ | 默认分辨率 1728×1117，需改配置 |
| MacBook Pro 13" (M1-M2) | ✅ | 无刘海，但热区功能可用 |
| MacBook Air 13"/15" (M2+) | ✅ | 有刘海机型 |
| Intel Mac | ⚠️ | 未测试，displayplacer 支持 |

## 📄 License

MIT —— 随便用，改了更好用记得 PR 回来。

## 🤝 贡献

这是 Mac 小工具脚本集的第一个。如果你也有好用的 Mac 效率脚本，欢迎提 PR 加入这个仓库。

---

Made with 🍎 by [HackerChi](https://github.com/HackerChi-Hub)
