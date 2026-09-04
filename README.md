# CF_BGR

> Bandgap Reference

Draft for designer review. Electrical values below are transcribed from the
packaging source extract. This package is not marked silicon-proven. The public
GDS is an abstract; ChipFoundry substitutes protected full geometry at tapeout.

## Overview

`CF_BGR` is a SkyWater 130 nm hard macro that generates a curvature-corrected
voltage bandgap and a trimmed current reference for on-chip analog blocks.

The voltage path is a second-order current-voltage bandgap: PTAT, CTAT, and
nonlinear (INL) currents are summed in a resistor ladder to cancel the
temperature dependence of \(V_{BE}\). A 7-bit temperature-coefficient trim
(`trimTC`) sets the slope. Companion trim-buffer cells in the original IP
family produce additional scaled voltages (0.256 V through 1.2 V); this package
ships the four top-level bandgap variants listed under Features.

The current path provides trimmed sink and source references. Temperature
coefficient and absolute value are trimmed separately (`trimCurr`,
`CurrAbsTrim`). Typical named outputs are approximately 2.4 µA / 2.5 µA sink
and 9.6 µA / 10 µA source, depending on the variant.

The block is specified for industrial temperature (−40 °C to 100 °C) on a
1.6–2.0 V analog supply. After trim, the source claims &lt; 20 ppm/°C and
±0.2% on the voltage reference, and ±3% on the current reference. Typical
supply current is 100 µA. Startup from power-down is specified at ≤ 10 µs
(about 7 µs when the analog supply is already stable).

The output has no DC drive: load current must stay in the tens of nA. Voltage
users should take a buffered copy, not the raw bandgap node. Current users
should treat the bias nodes as a low-impedance, well-decoupled distribution.

### Function

Generate a trimmed DC voltage reference and trimmed bias currents, with
independent power-down of the voltage and current paths, DFT muxes for
production trim, and optional startup-boost pins on the `CF_BGR_psoc3_revB`
variant.

## Installation

```bash
pip install cf-ipm
ipm install CF_BGR --version 0.1.1 --include-drafts
```

Until the marketplace listing is published, install from a local catalog
override the same way `cf-bgr-test-project` does:

```bash
ipm install CF_BGR --version 0.1.1 --include-drafts --local-file ip/catalog.json
```

Use `hdl/gl/` as the blackbox, `layout/lef/` for P&R, `layout/gds/` for the
public abstract, and `timing/lib/` for characterized views that shipped with
this package.

## Features

- Second-order curvature-corrected voltage bandgap
- Independent voltage (`pd`) and current (`pd_ibg`) power-down, both active-high
- Voltage tempco trim: `trimTC[6:0]` (plus `finetune` on `CF_BGR_psoc3_revB`)
- Current tempco trim and absolute trim (`trimCurr`, `CurrAbsTrim`; width varies by variant)
- INL / curvature trim via `inl_ctrl`
- DFT muxes: `mux1out` (currents), `mux2out` (voltage / ground); `mux1sel = 2'b11` loops an external current through `dft_curr_in` on the three larger variants
- PTAT and CTAT currents brought out for characterization
- Analog supply 1.6–2.0 V, industrial −40 °C to 100 °C
- Typical IDD 100 µA; startup ≤ 10 µs
- Four hard-macro variants in this package:

| Cell | Size (µm) | Current outputs | Notes |
|---|---|---|---|
| `CF_BGR` | 408.465 × 256.25 | `ibg_2p5uA`, `ibg_10uA` | Primary cell. Narrower absolute/INL buses. |
| `CF_BGR_psoc3_revA` | 408.465 × 281.25 | `ibg_2p375uA`, `ibg_3uA` | Adds `dft_curr_in`. |
| `CF_BGR_psoc3_revB` | 408.465 × 281.22 | `ibg_2p375uA`, `ibg_3uA` | Widest pinout: INL, fine trim, startup boost. |
| `CF_BGR_tspsoc` | 408.465 × 281.25 | `ibg_2p375uA`, `ibg_3uA` | Adds CTAT bias pins; 3-bit `inl_ctrl`. |

Instantiate `CF_BGR` unless a design specifically needs the extra trim or
startup pins on another variant.

### Architecture

- Voltage bandgap: IPTAT + ICTAT + INL currents into a resistor ladder; `Vout` is the summed reference.
- Current bandgap: trimmed PTAT/CTAT balance; `vbias` / `vbias_cascode` drive mirrors.
- DFT: `dft_sel` enables `mux1sel` / `mux2sel` onto `mux1out` / `mux2out`. `mux1sel = 2'b11` selects the external-current loop on variants that have `dft_curr_in`.
- `CF_BGR_psoc3_revB` adds a startup-boost path (`en_startb`, `vb2_fast`, `boost3`–`boost7`).
- PNP devices used for \(V_{BE}\) sit in the p-substrate; they are not placed in deep n-well. Bulk pins are not switched inside the macro.

## Block Diagram

Symbol crop for `CF_BGR_psoc3_revB` (widest pinout). Placeholders such as
`(CDFcellName)` are leftovers from the source symbol, not customer net names.
The primary `CF_BGR` cell is a subset of this pinout (see Pin Description).

![CF_BGR_psoc3_revB symbol](doc/generated/CF_BGR_chart_01.png)

## Pin Description

Directions and widths are taken from the shipped Verilog in `hdl/gl/`.
Descriptions are from the packaging extract where they match those stubs.

### `CF_BGR`

| Name | Direction | Width | Description |
|---|---|---:|---|
| `Vout` | output | 1 | Bandgap voltage output. No DC drive; keep load current to tens of nA. |
| `ictat` | output | 1 | CTAT current (characterization / trim). |
| `iptat` | output | 1 | PTAT current (characterization / trim). |
| `ibg_2p5uA` | output | 1 | Current-sink output. Typical 2.4 µA in the source; pin name is 2.5 µA. Keep ≥ ~400 mV VDS. |
| `ibg_10uA` | output | 1 | Current-source output. Typical 9.6 µA in the source; pin name is 10 µA. Keep ≥ ~550 mV VDS. |
| `mux1out` | output | 1 | DFT current mux (ICTAT / IPTAT / INL / Iref, or the `dft_curr_in` loop on other variants). |
| `mux2out` | output | 1 | DFT voltage mux (`Vout` or `vgnd` when DFT is on). |
| `vbias` | output | 1 | Bias voltage for current mirrors. |
| `vbias_cascode` | output | 1 | Cascode bias for current mirrors. |
| `dft_sel` | input | 1 | DFT enable, active high (`vpwr`). |
| `mux1sel` | input | 2 | DFT current-select. `2'b11` is the external-current loop on variants with `dft_curr_in`; the LSBs also fine-step INL on `CF_BGR_psoc3_revB`. |
| `mux2sel` | input | 1 | DFT voltage-select: `Vout` or `vgnd` onto `mux2out`. |
| `pd` | input | 1 | Power-down for the voltage bandgap, active high. |
| `pd_ibg` | input | 1 | Power-down for the current reference, active high. |
| `trimTC` | input | 7 | Voltage temperature-coefficient trim. |
| `trimCurr` | input | 7 | Current temperature-coefficient trim. Other variants use 6 bits. |
| `CurrAbsTrim` | input | 2 | Current absolute-value trim. Other variants use 6 bits. |
| `inl_ctrl` | input | 2 | Nonlinear / curvature current control. |
| `vpwr` | input | 1 | Analog supply, 1.6–2.0 V. |
| `vgnd` | input | 1 | Analog ground. |
| `vpb` | input | 1 | N-well bulk. Tie to the analog supply. |
| `vnb` | input | 1 | P-substrate bulk. Tie to analog ground. |

### Other variants

Pins shared with `CF_BGR` keep the same roles. Differences:

| Pin | `CF_BGR_psoc3_revA` | `CF_BGR_psoc3_revB` | `CF_BGR_tspsoc` |
|---|---|---|---|
| Current sinks | `ibg_2p375uA`, `ibg_3uA` (typ. 2.4 µA / 3 µA) | same | same |
| `trimCurr` | 6 bits | 6 bits | 6 bits |
| `CurrAbsTrim` | 6 bits | 6 bits | 6 bits |
| `inl_ctrl` | 2 bits | 7 bits (4 MSB crossover, 3 LSB current) | 3 bits |
| `dft_curr_in` | input; with `mux1sel = 2'b11` the current is looped out `mux1out` | same | same |
| `finetune` | — | input, extra voltage-tempco LSB with `trimTC` | — |
| `en_startb` | — | input, startup boost enable, active low | — |
| `vb2_fast` | — | input, fast-buffer bias into startup boost | — |
| `boost3`–`boost7` | — | outputs, boosted current during startup | — |
| `vout_ictat` | — | output, CTAT mirror bias | output, CTAT mirror bias |
| `pbias_ctat` | — | output, CTAT cascode bias | output, CTAT cascode bias |

## Specifications

Values are headline numbers from the source extract, not a re-characterized
Sky130 datasheet. Where the extract and the Verilog pin name disagree, both
are shown.

### Operating conditions

| Parameter | Min | Typ | Max | Unit |
|---|---:|---:|---:|---|
| Analog supply (`vpwr`) | 1.6 | 1.8 | 2.0 | V |
| Validated temperature | −40 | | 100 | °C |
| Junction (extract absolute max) | −40 | | 150 | °C |

### DC / accuracy (after trim)

| Parameter | Typ / value | Unit | Notes |
|---|---|---|---|
| Voltage temperature coefficient | &lt; 20 | ppm/°C | Curvature-corrected architecture |
| Voltage absolute accuracy | ±0.2 | % | |
| Current accuracy | ±3 | % | |
| Supply current (IDD) | 100 | µA | Core bandgap |
| Startup from power-down | ≤ 10 | µs | ~7 µs if analog supply already stable |
| `ibg_2p5uA` / `ibg_2p375uA` typical | 2.4 | µA | Sink to ground inside the macro |
| `ibg_10uA` typical | 9.6 | µA | Source |
| `ibg_3uA` typical | 3 | µA | Sink; revA / revB / tspsoc |
| Current-source compliance | ≥ ~550 | mV | VDS on source outputs (`ibg_10uA` / 9.6 µA class) |
| Current-sink compliance | ≥ ~400 | mV | VDS on sink outputs |
| Voltage DFT / probe impedance | ≥ 80 | MΩ | 80 MΩ is the source trim-path figure; ≥100 MΩ is acceptable, >1 GΩ preferred |
| Voltage output load | tens of nA | | No DC drive capability |

### Physical

| Cell | Width (µm) | Height (µm) | Area (µm²) |
|---|---:|---:|---:|
| `CF_BGR` | 408.465 | 256.25 | 104 669 |
| `CF_BGR_psoc3_revA` | 408.465 | 281.25 | 114 881 |
| `CF_BGR_psoc3_revB` | 408.465 | 281.22 | 114 869 |
| `CF_BGR_tspsoc` | 408.465 | 281.25 | 114 881 |

Source area claim for the core was 115 kµm²; use the LEF `SIZE` above for P&R.

### Operating Modes and Sequences

#### Normal

`pd = 0`, `pd_ibg = 0`. Voltage and current references enabled.

#### Voltage only

`pd = 0`, `pd_ibg = 1`. Voltage bandgap on; current reference off.

#### Power-down

`pd = 1`. Voltage and current paths off. The macro still draws leakage.
There is no internal power switch on these four cells.

#### DFT / trim

`dft_sel = 1` and `pd = 0`. Keep `pd_ibg = 0` if current DFT is required.

| Select | Action |
|---|---|
| `mux2sel` | Steers `Vout` or `vgnd` onto `mux2out`. |
| `mux1sel` | Steers internal currents (ICTAT, IPTAT, INL, Iref) onto `mux1out`. |
| `mux1sel = 2'b11` | On `CF_BGR_psoc3_revA`, `CF_BGR_psoc3_revB`, and `CF_BGR_tspsoc`, loops `dft_curr_in` out `mux1out` so an external current can be trimmed through the same path. The primary `CF_BGR` stub has no `dft_curr_in` pin. |

DFT and probe paths are high impedance. Plan for at least 80 MΩ on the voltage trim node; ≥100 MΩ is acceptable and >1 GΩ is preferred. Do not treat `mux1out` / `mux2out` as low-Z force pins.

#### INL / curvature (`CF_BGR_psoc3_revB`)

`inl_ctrl` is 7 bits on this variant. Two INL current legs stay on; the remaining codes add legs and fine steps:

| Field | Function | Source extract |
|---|---|---|
| `inl_ctrl[6:3]` | Crossover (temperature knee) | ~2° typical step, about ±15° range |
| `inl_ctrl[2:0]` | INL current legs | 2–9 legs in steps of 1 (`0` enables the switch) |
| `mux1sel[1:0]` | Extra INL LSBs | 0.5 and 0.25 leg steps; also ~0.45 mV typical / ±7 mV range |

`CF_BGR` and `CF_BGR_psoc3_revA` only expose 2-bit `inl_ctrl`. `CF_BGR_tspsoc` exposes 3 bits. Connect the width in the chosen Verilog stub.

#### Default trim codes

Use these mid-scale codes from the source as a bring-up starting point, then replace them with lot trim. They apply to the 7/6/6-bit buses on the three larger variants; `CF_BGR` has a 2-bit `CurrAbsTrim` and a 7-bit `trimCurr`, so only `trimTC` matches this table directly.

| Bus | Suggested reset | Notes |
|---|---|---|
| `trimTC[6:0]` | `7'b0111111` | Voltage temperature coefficient |
| `trimCurr[5:0]` | `6'b011111` | Current temperature coefficient (6-bit variants) |
| `CurrAbsTrim[5:0]` | `6'b100000` | Current absolute (6-bit variants) |
| `inl_ctrl[2:0]` | `3'b101` | Silicon INL default in the extract (`3'b010` was the simulation default) |

Apply trim before deasserting `pd` if the ±0.2% / 20 ppm/°C / ±3% figures are required. Production trim uses two or three temperature points; two-point trim is less accurate.

### Integration Requirements

- Tie `vpwr`/`vpb` to the 1.8 V analog supply and `vgnd`/`vnb` to analog ground.
- Keep current-source outputs at ≥ ~550 mV VDS and current-sink outputs at ≥ ~400 mV VDS.
- Probe `Vout` / DFT voltage with ≥80 MΩ (prefer >1 GΩ). A 50 Ω or 10 MΩ meter will pull the reference.
- Do not route unrelated signals over the macro without shielding.
- Shield reference routes leaving the macro. If a reference must cross a switching net, shield it on all four sides (co-axial).
- Do not tap an unbuffered trim-buffer output as a chip-level reference.
- Give each consumer its own low-power buffer; the bandgap pin itself cannot drive DC current.
- Add RC filtering on voltage outputs if the application PSRR needs it; that increases startup time.
- Keep maximum ground-bus resistance within the analog budget; a small load capacitance improves AC PSRR.
- Place the bandgap variants that share this bias system together; do not scatter them.
- PNP \(V_{BE}\) devices stay in the p-substrate (not DNW). Do not switch bulks inside the IP.

`cf-bgr-test-project` wires `CF_BGR` analog outputs to Caravel GPIO analog
pads 7–15 and drives trim / `pd` / DFT from Logic Analyzer bits 0–23. With
those probes at power-on zero, `pd` and `pd_ibg` are low, so the macro comes
up enabled.

## Timing Diagram

This is a DC analog reference. There is no clocked timing diagram.

Power-down and DFT are level-sensitive:

1. Analog `vpwr`/`vgnd` stable.
2. Drive `trimTC`, `trimCurr`, `CurrAbsTrim`, and `inl_ctrl` to the intended codes (see default trim table).
3. Deassert `pd` (and `pd_ibg` if current outputs are needed).
4. Wait the startup window (≤ 10 µs) before using `Vout` or the current pins.
5. Assert `dft_sel` only for trim or characterization. Use `mux1sel = 2'b11` only when looping `dft_curr_in`.

On `CF_BGR_psoc3_revB`, `en_startb` (active low) and `vb2_fast` gate the
startup-boost currents `boost3`–`boost7`. Leave them off for DC operation
unless that path is required.

## Limitations and Open Issues

- Validated in the source only for industrial −40 °C to 100 °C.
- Downstream buffered references will be worse than the core ±0.2% (source cites about ±1% in the distribution chain).
- Two-temperature trim is less accurate than three-temperature trim.
- Trim range is not symmetrical; it was centered from measured lots.
- No DC current drive; overload on `Vout` will pull the reference.
- Power-down is functional disable, not a supply switch. Leakage remains.
- Verilog in `hdl/gl/` is a behavioral blackbox (enable / DFT stubs), not a
  SPICE-accurate model.
- Pin widths on `CF_BGR` (`trimCurr` 7 bits, `CurrAbsTrim` 2 bits, `inl_ctrl`
  2 bits) do not match the 6-bit current buses on the other three variants.
  Connect what the chosen Verilog stub declares.
- Public abstracts use Sky130 `prBoundary` 235/4 and OBS on blockage datatype
  10. Edge pins that stopped short of the boundary in the vendor `lefout` were
  snapped out to the PR boundary (≤ 50 nm).
- Companion cells (trim buffer, 5 µA buffers, VREF/VCM buffers) appear in
  some Liberty files but are not shipped as separate HDL/LEF/GDS macros in
  this package.

## Tapeout History

This package is not marked silicon-proven in IPM metadata (`maturity: np`).
The customer tree contains abstract integration views. Protected full layout
is merged by ChipFoundry during tapeout.

| Version | Date | Notes |
|---|---|---|
| 0.1.0 | 2026-09-03 | First unpublished IPM draft. |
| 0.1.1 | 2026-09-04 | Public LEFs stripped of leftover `lefout` VIA/VIARULE blocks so OpenROAD can load them. |
