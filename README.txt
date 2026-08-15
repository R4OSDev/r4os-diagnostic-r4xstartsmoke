R4XSTARTD.R4X
=============

R4XSTARTD.R4X ist die R4XStart-Smoke-Diagnose.

Projektstruktur seit 0.51.21:
- `build.zig` baut die Diagnose als eigenes SDK-Projekt.
- `build.zig.zon` bindet `r4os_sdk` als Paket.
- `module.R4MF` beschreibt Artefakt, Zielpfad, R4L-Imports und Contract.

Build:

    cd Code\System\Diagnostics\R4XStartSmoke
    ..\..\..\DevTools\Zig\zig.exe build

Ergebnis:

    Code\System\Diagnostics\R4XStartSmoke\zig-out\R4XSTARTD.R4X

Contract:
- Build-Profil: `Zig/R4XStart`
- R4XStart-Entry: `r4xstart_smoke_main`
- App-Klasse: `console`
- R4L-Imports: `R4SYS`
- Zielpfad im Image: `C:\R4OS\SOFTWARE\TERMINAL\DIAG\R4XSTARTD.R4X`
