# CF_BGR

## Overview

CF_BGR is a ChipFoundry hard macro for customer integration as a blackbox. The public package contains abstract views only. Full layout is merged at tapeout and is not delivered to the licensee. This overview exists so the README meets IPM documentation length. Do not treat placeholder sentences as electrical specs.

## Installation

Install through IPM after the GitHub release exists. Add the blackbox Verilog, LEF, and Liberty files to the digital flow as EXTRA_LEFS, EXTRA_GDS, and VERILOG_FILES_BLACKBOX. Until a release URL is published, this section documents the intended customer path rather than a live install command.

## Features

Bandgap Reference (CF_BGR) is a ChipFoundry hard-macro blackbox on SkyWater 130 nm. Public deliverables are a blackbox Verilog stub for top-level integration, Liberty timing when present, and a Verilog behavioral model under verify/beh_model for functional simulation. Abstract GDS and LEF carry the boundary and pins. Spice and transistor-level netlists are not part of the license grant.

## Block Diagram

A block diagram is not generated from geometry. The customer-facing description is this README (same pattern as published ChipFoundry hard macros). Optional figures may be placed under doc/.

## Pin Description

### `s8bg_top_psoc3_revB`

| Pin | Direction | Width |
|---|---|---|
| Vout | output | 1 |
| ictat | output | 1 |
| iptat | output | 1 |
| ibg_2p375uA | output | 1 |
| ibg_3uA | output | 1 |
| mux1out | output | 1 |
| mux2out | output | 1 |
| vbias | output | 1 |
| vbias_cascode | output | 1 |
| boost3 | output | 1 |
| boost4 | output | 1 |
| boost5 | output | 1 |
| boost6 | output | 1 |
| boost7 | output | 1 |
| vb2_fast | input | 1 |
| en_startb | input | 1 |
| dft_curr_in | input | 1 |
| dft_sel | input | 1 |
| mux1sel | input | 2 |
| mux2sel | input | 1 |
| pd | input | 1 |
| pd_ibg | input | 1 |
| trimCurr | input | 6 |
| trimTC | input | 7 |
| finetune | input | 1 |
| vgnd | input | 1 |
| CurrAbsTrim | input | 6 |
| inl_ctrl | input | 7 |
| vnb | input | 1 |
| vpb | input | 1 |
| vpwr | input | 1 |
| vout_ictat | output | 1 |
| pbias_ctat | output | 1 |

### `s8bg_top`

| Pin | Direction | Width |
|---|---|---|
| Vout | output | 1 |
| ictat | output | 1 |
| iptat | output | 1 |
| ibg_2p5uA | output | 1 |
| ibg_10uA | output | 1 |
| mux1out | output | 1 |
| mux2out | output | 1 |
| vbias | output | 1 |
| vbias_cascode | output | 1 |
| dft_sel | input | 1 |
| mux1sel | input | 2 |
| mux2sel | input | 1 |
| pd | input | 1 |
| pd_ibg | input | 1 |
| trimCurr | input | 7 |
| trimTC | input | 7 |
| vgnd | input | 1 |
| CurrAbsTrim | input | 2 |
| inl_ctrl | input | 2 |
| vnb | input | 1 |
| vpb | input | 1 |
| vpwr | input | 1 |

### `s8bg_top_psoc3_revA`

| Pin | Direction | Width |
|---|---|---|
| Vout | output | 1 |
| ictat | output | 1 |
| iptat | output | 1 |
| ibg_2p375uA | output | 1 |
| ibg_3uA | output | 1 |
| mux1out | output | 1 |
| mux2out | output | 1 |
| vbias | output | 1 |
| vbias_cascode | output | 1 |
| dft_curr_in | input | 1 |
| dft_sel | input | 1 |
| mux1sel | input | 2 |
| mux2sel | input | 1 |
| pd | input | 1 |
| pd_ibg | input | 1 |
| trimCurr | input | 6 |
| trimTC | input | 7 |
| vgnd | input | 1 |
| CurrAbsTrim | input | 6 |
| inl_ctrl | input | 2 |
| vnb | input | 1 |
| vpb | input | 1 |
| vpwr | input | 1 |

### `s8bg_top_tspsoc`

| Pin | Direction | Width |
|---|---|---|
| Vout | output | 1 |
| ictat | output | 1 |
| iptat | output | 1 |
| ibg_2p375uA | output | 1 |
| ibg_3uA | output | 1 |
| mux1out | output | 1 |
| mux2out | output | 1 |
| vbias | output | 1 |
| vbias_cascode | output | 1 |
| vout_ictat | output | 1 |
| pbias_ctat | output | 1 |
| dft_curr_in | input | 1 |
| dft_sel | input | 1 |
| mux1sel | input | 2 |
| mux2sel | input | 1 |
| pd | input | 1 |
| pd_ibg | input | 1 |
| trimCurr | input | 6 |
| trimTC | input | 7 |
| vgnd | input | 1 |
| CurrAbsTrim | input | 6 |
| inl_ctrl | input | 3 |
| vnb | input | 1 |
| vpb | input | 1 |
| vpwr | input | 1 |


## Specifications

Electrical specifications belong in this README and in Liberty. This packager does not invent PVT tables. Timing numbers are copied from Liberty when those files are present; they are not estimated.

## Timing Diagram

Timing diagrams are not synthesized from stubs. Clock, reset, and enable polarity must match the behavioral model and Liberty when those files are present in a release.

## Tapeout History

Not silicon proven in this ChipFoundry package version. Maturity is not proven until a shuttle returns. Foundry merge substitutes vault GDS for the public abstract at tapeout.
