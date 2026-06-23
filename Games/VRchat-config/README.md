tty(0.46.2)  问题	修复
nixos 目录里没有 .git，但 git 只追踪了空目录占位符	git rm --cached nixos + git add nixos/ 重新追踪文件
SSH 用了默认密钥路径，但你的密钥叫 mygithub.key	创建了 ~/.ssh/config 指向 IdentityFile ~/./mygithub.key
密钥没加载到 ssh-agent	ssh-add ~/.ssh/mygithub.key# VRChat 极致帧率优化配置

> ⚠️ **免责声明：本配置由 Step 3.7 Flash 自动生成，请谨慎使用。**
> 优化涉及修改注册表、系统 GPU 设置、游戏配置文件等，
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
| **系统** | Arch Linux (kernel 6.x) + niri Wayland |
| **显卡驱动** | NVIDIA 580.159.04 |
| **转译层** | Proton 10.0 / DXVK |
| **显示器** | 1440×900 (16:9, 等效缩放窗口800×450) |

> **性能瓶颈：** 940MX 是 2016 年入门级独显，2GB VRAM 严重不足，
> 在 VRChat 这种开放世界多人游戏中尤其吃力。
> i5-6300U 也是 6 代低压 U，2C4T 在多线程渲染上力不从心。

---

## 📊 优化项目与预计帧率提升

> 以下估算基于 940MX + 2GB VRAM + 800×450 渲染分辨率。
> 实际帧率受世界复杂度、同屏玩家数、头像质量影响极大。

| # | 优化项 | 优化前 FPS | 优化后 FPS | 单项目提升 | 说明 |
|---|--------|----------|----------|----------|------|
| 1 | **FPS上限解封** | 20 🔴 | 72 | **+250%** | 原锁定20帧，改为72帧 |
| 2 | **分辨率** | 40 | 45 | +5 | 1024×768→800×450，减少像素填充 |
| 3 | **抗锯齿关闭** | 45 | 52 | +7 | MSAA 关闭省 GPU |
| 4 | **阴影=0** | 52 | 58 | +6 | 阴影贴图降到16px |
| 5 | **LOD=0** | 58 | 63 | +5 | 远处模型不渲染 |
| 6 | **粒子物理关闭** | 63 | 66 | +3 | CPU 省回主循环 |
| 7 | **像素光=0** | 66 | 68 | +2 | 逐像素光照关闭 |
| 8 | **Bloom禁用** | 68 | 69 | +1 | 后处理链简化 |
| 9 | **SteamAudio全关** | 69 | 72 | +3 | HRTF 音频不再占 CPU |
| 10 | **头像限制1MB** | 72 | 75 | +3 | 大 avatar 不再加载 |
| 11 | **安全等级2(全屏蔽)** | 75 | 80 | +5 | 不渲染其他玩家 |
| 12 | **boot.config Unity优化** | 80 | 83 | +3 | 渲染路径简化 |
| 13 | **DXVK 1线程+显存整理** | 83 | 85 | +2 | 减少驱动开销 |
| 14 | **GPU P0+风扇100%** | 85 | **90** | **+5** | 避免降频 throttling |

### 综合预估帧率

| 场景 | 优化前 | 优化后 | 提升 |
|------|-------|-------|------|
| **空地图/个人空间** | 20-30 FPS | **80-90 FPS** | **~3x** |
| **小型世界 (10人以内)** | 15-25 FPS | **60-75 FPS** | **~3x** |
| **大型公共世界** | 10-20 FPS | **40-55 FPS** | **~3x** |
| ** crowded 世界 (30人+)** | 5-15 FPS | **30-45 FPS** | **~3x** |

> ⚠️ 以上为disable-vr桌面模式下的估算。
> 实际表现受：同屏头像数量、世界作者画质、粒子特效密度、
> 是否开启安全模式(屏蔽)、音频设置等影响。
> **最有效的单步操作是：Steam启动选项 + FPS解封 + 分辨率降低。**

---

## 🚀 使用方法

### 1. 一键配置（仅需一次，或重置后）

```bash
cd dotfile-niri/VRchat-config
./apply.sh
```

### 2. Steam 启动选项

右键 VRChat → 属性 → 启动选项，粘贴：
```
--enable-sandbox=False --disable-vr --screen-width 800 --screen-height 450 --window-mode exclusive
```

### 3. 每次启动前

```bash
cd dotfile-niri/VRchat-config
./set_gpu_perf.sh
```

### 4. 游戏内设置

- 性能 → 全部最低
- 抗锯齿 → 关闭
- 分辨率缩放 → 最低
- 安全 → 屏蔽所有不在友好名单的玩家
- 头像性能 → VeryPoor / None

## 📁 文件说明

| 文件 | 作用 |
|------|------|
| `apply.sh` | 一键配置脚本（DXVK/boot/注册表/分辨率/缓存） |
| `set_gpu_perf.sh` | 设置 GPU P0性能模式+风扇100% |
| `boot.config` | Unity 引擎启动参数优化 |
| `dxvk.conf` | DXVK 转译层性能配置 |
| `vrchat_registry_settings.txt` | 注册表原始值备份（参考用） |
| `README.md` | 本文件 |

## 🔧 恢复默认

```bash
# 恢复注册表 FPS
sed -i 's/FPS_LIMIT.*dword:00000048/FPS_LIMIT.*dword:00000014/' \
  ~/.local/share/Steam/steamapps/compatdata/438100/pfx/user.reg
sed -i 's/FPSType.*dword:00000003/FPSType.*dword:00000002/' \
  ~/.local/share/Steam/steamapps/compatdata/438100/pfx/user.reg

# 删除自定义 dxvk.conf
rm ~/.local/share/Steam/steamapps/compatdata/438100/pfx/drive_c/users/steamuser/AppData/Local/dxvk/dxvk.conf

# 恢复 boot.config
mv ~/.local/share/Steam/steamapps/common/VRChat/VRChat_Data/boot.config.bak \
   ~/.local/share/Steam/steamapps/common/VRChat/VRChat_Data/boot.config
```

---

> ⚠️ **再次提醒：本配置由 Step 3.7 Flash 生成，请谨慎使用。**
> 优化越激进，越容易引发不稳定。如遇问题请先恢复默认设置。
