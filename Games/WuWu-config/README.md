tty(0.46.2)  问题	修复
nixos 目录里没有 .git，但 git 只追踪了空目录占位符	git rm --cached nixos + git add nixos/ 重新追踪文件
SSH 用了默认密钥路径，但你的密钥叫 mygithub.key	创建了 ~/.ssh/config 指向 IdentityFile ~/./mygithub.key
密钥没加载到 ssh-agent	ssh-add ~/.ssh/mygithub.keytty(0.46.2)  都写一份REDME.md，并声明全程由Step 3.7 Flash生成# 鸣潮 (Wuthering Waves) 极致帧率优化配置

> ⚠️ **免责声明：本配置由 Step 3.7 Flash 自动生成，请谨慎使用。**
> 优化涉及修改 Wine 注册表、系统 GPU 设置、游戏配置文件等，
> 可能导致游戏不稳定、闪退或封号风险。
> 使用前请备份重要数据，作者不承担任何责任。

---

## 🖥️ 当前电脑配置 (2026-06-23)

| 硬件 | 型号/规格 |
|------|----------|
| **CPU** | Intel Core i5-6300U (2C/4T, 2.40GHz, Skylake) |
| **GPU** | NVIDIA GeForce 940MX (2GB GDDR5, Maxwell架构) |
| **内存** | 15 GB DDR3L |
| **存储** | NVMe SSD |
| **系统** | Arch Linux + dwproton-10.0-14 + Lutris |
| **显卡驱动** | NVIDIA 580.159.04 |
| **转译层** | DXVK + Wine |

> **性能瓶颈：** 940MX 仅 2GB VRAM，对 UE4 开放世界游戏极其吃力；
> i5-6300U 为 2016 年低压双核，CPU 也是瓶颈。

---

## 📊 优化项目与预计帧率提升

> 以下基于 940MX + 640x360 窗口 + Proton 估算。
> 实际帧率受场景复杂度、同屏敌人/特效数量、分辨率动态缩放影响。

| 优化项 | 优化前 FPS | 优化后 FPS | 提升 |
|--------|----------|----------|------|
| SimpleForwardShading | 基准 | +8 | Maxwell 延迟→前向，最大单提升 |
| 分辨率 640x360 | 基准 | +6 | 像素 -75% |
| ScreenPercentage=20% | ~35 | ~42 | +7 | 内部再压 |
| 阴影全关 | 42 | 48 | +6 | 16px 阴影 |
| 后处理全关 | 48 | 53 | +5 | Bloom/DoF 全关 |
| 体积效果全关 | 53 | 57 | +4 | 雾/云/大气关闭 |
| 纹理池32MB+MipBias5 | 57 | 60 | +3 | 显存带宽↓ |
| 视距0.01+LOD bias5 | 60 | 63 | +3 | 远处不渲染 |
| SSR/SSGI/粒子/水全关 | 63 | 66 | +3 | 反射/粒子关闭 |
| FrameRateLimit=120 | 66 | 72 | +6 | 解除 60 上限 |
| SG ResolutionQuality=20% | 72 | 76 | +4 | 动态分辨率更激进 |
| 音频 22kHz | 76 | 78 | +2 | Wwise CPU ↓ |
| CrashSight 禁用 | 78 | 79 | +1 | 遥测停止 |
| DXVK 1线程+显存整理 | 79 | 80 | +1 | 驱动开销↓ |
| GPU P0+风扇100% | 80 | 82-88 | +2~8 | 避免降频 |

### 综合预估帧率（鸣潮）

| 场景 | 优化前 | 优化后 | 提升 |
|------|-------|-------|------|
| 城镇/主城 | 25-35 FPS | 60-75 FPS | ~2.5x |
| 野外跑图 | 30-40 FPS | 70-85 FPS | ~2.5x |
| 战斗(小怪) | 20-30 FPS | 55-70 FPS | ~2.5x |
| 战斗(BOSS/特效多) | 15-25 FPS | 45-60 FPS | ~2.5x |
| 剧情/对话 | 30-40 FPS | 75-88 FPS | ~2.5x |

---

## 🚀 使用方法

```bash
# 一键配置
cd dotfile-niri/WuWu-config
./apply.sh

# 每次启动前
cd dotfile-niri/WuWu-config
./set_gpu_perf.sh
```

## 📁 文件说明

| 文件 | 作用 |
|------|------|
| apply.sh | 一键配置脚本 |
| set_gpu_perf.sh | GPU P0+风扇100% |
| GameUserSettings.ini | 分辨率/FPS/质量 |
| Engine.ini | UE4 渲染参数(80+条) |
| Scalability.ini | 画质组缩放 |
| Hardware.ini | GPU 识别 |
| RuntimeOptions.ini | 运行时优化 |
| Wwise.ini | 音频最低质量 |
| CrashSight.ini | 禁用遥测 |
| DeviceProfiles.ini | 强制 Low 配置 |

---

> ⚠️ **再次提醒：本配置由 Step 3.7 Flash 生成，请谨慎使用。**
> 画面糊是正常的（640x360），追求画质请勿使用此配置。
