# MeMu / Bluestacks ADB PowerShell Automation Script

Reverse engineered tap behaviour with AI assistance, but thoroughly tested because I actually use it myself.

This is a PowerShell script that sends low-level touch events to an Android emulator over ADB. It automates a bunch of repetitive taps for a mobile game. It is mainly tuned for **MeMu**, but a Bluestacks variant is included.

**Before you run it and go AFK: watch it complete a few full loops first.** It clicks blindly based on screen coordinates. If your UI layout differs from mine, it will click the wrong things.

## Requirements

- Windows with PowerShell
- `adb` installed and available in your PATH
- An Android emulator set to:
  - **Resolution:** 1080 x 1920
  - **Orientation:** Portrait
  - **Render mode:** DirectX (other modes may work but are not tested)
- ADB access enabled / configured for your emulator

## Repo Layout

```
├───Bluestacks
│       ADB-Commands-Bluestacks.ps1
│       Tap-Screen-ADB-Bluestacks.ps1
│
└───MeMu
        ADB-Commands-MeMu.ps1
        Tap-Screen-ADB-MeMu.ps1
```

Pick the folder that matches your emulator and run the `Tap-Screen-ADB-*.ps1` script.

If you move the files around, update the relative import path at the top of the tap script so it can still find `ADB-Commands-*.ps1`.

## Emulator Setup

Scroll the in-game shop down until the **Claim** button of the Freebie packs is just slightly above the bottom bar (the one that says **Loot tables**). The script expects the buttons to be in roughly that position.

Example: <br>
<img width="509" height="368" alt="image" src="https://github.com/user-attachments/assets/f0f5d469-cfe7-4ae5-8092-36c99dcc7c81" />


## Configuration

These toggles live at the top of `Tap-Screen-ADB-MeMu.ps1` / `Tap-Screen-ADB-Bluestacks.ps1`. Change them to suit what you want.

| Variable | Default | What it does |
|---|---|---|
| `$FoundersDrops` | `$true` | Claims the founders supply drops. |
| `$Lootbugs` | `$true` | Clicks the lootbugs. It does them one at a time, not using Loot All. Order is Bug 1 > Bug 2 > Bug 3, repeated 4 times. You can tweak this by editing how many times `ClickLootbugs` is called. |
| `$LootBugPremium` | `$false` | Whether to buy premium lootbugs or just close them. |
| `$Stargazing` | `$false` | Opens the Stargazing menu, selects Stars, buys the top star upgrade if possible, then uses the Jump to Star option on the top-most star. Mostly legacy behaviour. |
| `$Gifts` | `$true` | Claims freebie gifts. |
| `$MoveEnabled` | `$false` | Tries to line up the gift claim to the right spot. I do not recommend using this. With shop items changing it is unreliable without screen capture. |
| `$Prestige` | `$false` | Automatically prestiges. Make sure you also read what `$Pickaxe` does and check the timeouts. |
| `$BombFiring` | `$true` | Fires bombs automatically. Order is: Gem, then (Founders > Battery > D20 > Cherry > Gem) repeated 3 times, then Chain bomb. |
| `$PrestigeWaitTimeout` | `300` | Seconds to wait before prestiging again. While waiting it will loop over lootbugs and upgrade pickaxe if enabled, otherwise it just waits. |
| `$EndTimeout` | `15` | Seconds to wait before re-looping the script. |
| `$Pickaxe` | `$true` | Opens menu > Bars > Craft all bars > opens menu again > Upgrades > Buy all upgrades. |
| `$LevelIndex` | `0` | Index used by `$CycleLevels`. |
| `$CycleLevels` | `$false` | Whether to periodically change floors. Currently only set up for World 3, but you can adjust the arrays. |
| `$Levels` | `Level 90, 96, 102` | Floor rotation list. Yes, they are technically called floors, not levels. |
| `$Levels2` | `Weighted 3:2:1` | Second example list with the same floors weighted 90/90/90/96/96/102. |

## Important Notes

- This is **not** intended to be intuitive or easy to use. It was built for myself and grew organically. I am sharing it as-is.
- Coordinates are fixed. Any UI change, popup, or different screen layout will break it.
- `adb shell input tap` did not work for this use case, which is why the script uses raw `sendevent` calls.

## My Setup

These are my settings and what works for me. It does **not** mean it will not work for lower or higher setups. It is just an FYI in case you are wondering why the timings might feel too quick or too slow for your setup.

<details>
<summary>**Not sure if contains SPOILERS but here are my stats at time of writing**</summary>

| Stat | Value |
|---|---|
| Obelisk Level | 70 |
| Max Artifact Levels | 645 / 645 |
| Challenges | 88 / 100 |
| Skill Tree | 93 / 97 |
| Workshop | 911 / 1201 |
| World 1 Statues | All Platinum |
| World 2 Statues | All Platinum |
| World 3 Statues | 4 / 9 |
| Pets | 482 / 541 |
| Legendary Fish Tributes | 21 / 22 |

</details>

## Support

No expectations. If you want to use it, do. But I am not promising it will be easy or intuitive, and my support will be limited. Feel free to ask questions, but this was never really meant for public use and would benefit from a rewrite. I have no desire to do that rewrite, so this is what you get.

Use at your own risk.