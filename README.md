# ArchLinux in WSL2
因為想用IaC的方式管理，且部分環境設定檔會用"硬連結"的方式進行同步，所以不使用[Windows商店提供的ArchLinux](https://apps.microsoft.com/store/detail/arch-wsl/9MZNMNKSM73X?hl=zh-tw&gl=tw&rtc=1)。
為了讓使用體驗更方便預設有安裝[wslu](https://github.com/wslutilities/wslu)工具。
第一次啟動後，需執行`fcitx5-configtool`設定中文輸入法。

## 未解問題
目前中文輸入法會無法正常使用，需在執行GUI程式前(要同一個shell上)，執行一次`restart_fxitx`。
