# Manual

## Get started

To get started with TrypColonies.jl, follow these steps:

1. **Download the Repository**: Clone or download the TrypColonies.jl.jl repository from GitHub to your local machine.

   ```bash
   git clone https://github.com/AndreasKuhn-ak/TrypColonies.jl.git  
    ``` 
2. **Navigate to the Package Directory**:  Open a terminal and change directory to the TrypColonies.jl.jl folder.
   ```bash
   cd TrypColonies
    ``` 
3. **Activate the Julia Environment**: Start Julia in the terminal and activate the package environment.
   ```bash
    julia  
   ``` 
   Within the Julia REPL, activate and instantiate the project :
   ```julia
      using Pkg
      Pkg.activate(".")
      Pkg.instantiate()
   ```
This sets up the environment with all necessary dependencies.

4. **Using TrypColonies.jl**: Now, you can start using TrypColonies.jl in your Julia scripts or REPL.
   ```julia
      using TrypColonies
   ```

5. **Necessary Packages**: To ensure that all scripts and Jupyter notebooks in this GitHub repository work correctly, you additionally need those two packages: IJulia (to use Julia inside Jupyter notebooks) and Revise (for a more comfortable workflow without constantly restarting the Julia kernel).
   ```julia
      using Pkg
      Pkg.add("IJulia")
      Pkg.add("Revise")
   ```

## Interactive Simulation Notebook

This notebook allows you to interactively run the model and adjust selected parameters in real time via a GLMakie window with sliders. These interactive simulations do not write any output to disk; only the current model state is held in memory.

Alternatively, you can record videos of a simulation run. The duration of these videos is determined by the `total_time` field of the `parameters_physical` struct. Videos are saved as `.mp4` files to the `vids/` folder.

### Parameter Structs

Model parameters are organised across three structs:

- **`parameters_physical`** — all parameters that carry physical units (e.g. system size, diffusion coefficient, agent speed). This struct is embedded as the `pa_ph` field of `parameters`.
- **`parameters`** — the top-level parameter struct. In addition to `pa_ph`, it controls flags and settings that are not tied to physical units (e.g. `chemotaxis_flag`, `geometry`, `start_config_gradient`).
- **`plot_parameters`** — controls the appearance of the visualisation (arrow size, frame rate, resolution, correlation function, etc.).

#### Physical model parameters (`parameters_physical`)

| Field | Example value | Description |
|---|---|---|
| `N` | `(1000, 1000)` | ABM grid dimensions (number of grid cells in x and y). |
| `L` | `(0.015, 0.015)` | Physical system size in metres (x, y). |
| `scale_fac` | `4` | Gradient grid scaling factor s_f relative to ABM grid. |
| `total_time` | `2000.0` | Total simulation time in seconds. |
| `agent_number` | `250000` | Initial number of agents. |
| `walker_speed_phy` | `5e-6` | Mean agent speed in m/s. |
| `Diff_coe` | `7e-11` | Diffusion coefficient of the chemical field in m²/s. |
| `walker_step_size` | `3` | Mean number of ABM grid cells traversed per agent time step. |
| `decay_rate` | `0.001` | Decay rate d_r of the chemical field. |
| `adsorption_rate` | `0.05` | Adsorption rate a_d of the chemical field per agent. |
| `Diameter_colony` | `0.003` | Initial colony diameter in metres. |
| `growth_rate` | derived | Per-agent probability of division per agent time step (see below). |
| `noise_strength` | `0.3` | Standard deviation η of the orientational noise. |
| `velo_var_relative` | `1.5` | Relative standard deviation of the agent speed distribution. |
| `Δt_walker_min` | `0.1` | Minimum agent time step Δt_a in seconds. |
| `grid_strength` | `150` | Initial boundary strength k₀. |
| `grid_recover_rate` | `15.0` | Rate at which boundary strength recovers between collisions. |
| `radius_collision` | `16` | Radius R_c (in ABM grid cells) of the boundary-weakening region upon collision. |
| `radius_tanget` | `15` | Radius R_t (in ABM grid cells) used to approximate the local boundary tangent. |

#### Deriving `growth_rate` from doubling time

The recommended way to set `growth_rate` is to derive it from a biologically observed population doubling time τ_d (in seconds):

```julia
doubling_time = 3600 * 9       # e.g. 9 h doubling time
growth_rate   = 2^(1/doubling_time) - 1
```

This corresponds to the formula r = 2^(1/τ_d) − 1 described in the model documentation. Procyclic *T. brucei* doubling times in experimental conditions typically range from roughly 9 h to 20 h.

#### Top-level flags (`parameters`)

| Field | Example value | Description |
|---|---|---|
| `pa_ph` | `parameters_physical(...)` | Embedded physical parameter struct (see above). |
| `chemotaxis_flag` | `true` | Enables negative auto-chemotactic alignment of agents. |
| `repulsion_flag` | `false` | Enables agent–agent repulsion. |
| `repulsion_range` | `2` | Range (in ABM grid cells) of the repulsion interaction. |
| `geometry` | `"circle"` | Initial colony geometry. |
| `start_config_gradient` | `"rand"` | Initialisation mode for the chemical gradient field. |

#### Visualisation parameters (`plot_parameters`)

| Field | Example value | Description |
|---|---|---|
| `arrow_tip_size` | `6` | Size of arrow tips in the agent vector plot. |
| `arrow_tail_length` | `0.00005` | Length of arrow tails in physical units. |
| `framerate` | `30` | Frame rate for video recording in fps. |
| `fontsize` | `15` | Font size in the figure. |
| `refresh_delay` | `0.005` | Delay in seconds between display refresh calls in interactive mode. |
| `res` | `(900, 1300)` | Figure resolution in pixels (width, height). |
| `draw_arrows` | `true` | Whether to render individual agent arrows. Disable for large agent numbers. |
| `cor_func_scalar` | `order_parameter` | Scalar correlation function computed and displayed live. |
| `cor_func_vector` | `pair_cor_metric` | Vector correlation function computed and displayed live. |
| `type_cor_func` | `"vector"` | Selects which correlation function type to display (`"scalar"` or `"vector"`). |
| `timesteps_corfunc` | `100` | Number of agent time steps between correlation function evaluations. |

### Provided Example Parameter Sets

Three example parameter sets are provided, each illustrating a different regime of the model:

1. **Small exploratory system** — 5 agents on a 200×200 grid (6×6 mm), moving at 3×10⁻⁵ m/s, which is considerably faster than real trypanosomes. This set is intended to build intuition for the effect of the various parameters without long computation times. Agent arrows are rendered (`draw_arrows = true`) so individual trajectories are visible.

2. **Default parameters, reduced agent count** — the default physical parameter values from the paper on a 1000×1000 grid (15×15 mm), but with only 2,500 agents. This is a good compromise between biological realism and computational speed. Agent arrows are rendered.

3. **Full default parameters** — the complete default parameter set from the paper: 250,000 agents on a 1000×1000 grid (15×15 mm) at biologically realistic speed (5×10⁻⁶ m/s). **Note:** this configuration is computationally demanding. Even with a multi-threaded Julia kernel, expect approximately real-time performance on hardware available in 2025 (i.e. roughly one simulation second per wall-clock second). Agent arrows are disabled (`draw_arrows = false`) as individual agents cannot be distinguished at this density. Use as many threads as you can spare, you can do this for example by creating a custom Julia kernel  more threads (in this case 8):

```julia
using IJulia

installkernel("Julia_8_Threads", env = Dict("JULIA_NUM_THREADS"=>"8"))
```


You are encouraged to modify any of these parameter values freely to explore the simulation space. For systematic exploration over a range of parameter values, use [`sweep_parallel.jl`] instead, which runs batches of simulations in parallel and saves results to disk.

## `sweep_parallel.jl`

This is the workhorse script of the package. It defines and executes parameter sweeps over the model, running multiple simulations in parallel across threads. There is no graphical output; all results are serialised to disk as `.jls` files (Julia serialisation format) and the setting of the simulation are additionally exported as human-readable `.txt` and `.csv` files.

### Overview of the workflow

1. Define all model parameters and sweep settings in the `settings` dictionary.
2. A uniquely named output folder is created automatically.
3. The parameter struct and settings saved to that folder for reproducibility.
4. The sweep is executed in parallel using all of the available Julia threads.
5. After completion, run metadata (path, date, runtime, storage size) is appended to a persistent database DataFrame (`data_base/df.jls` and `data_base/df.csv`).

### The `settings` dictionary

All model parameters and sweep control variables are defined in a single `Dict{String, Any}` called `settings`. This dictionary is passed to `make_para_dict_list`, which expands it into a list of parameter dictionaries — one per simulation — according to the sweep configuration.

#### Sweep control fields

| Field | Type | Description |
|---|---|---|
| `iterations` | `Int` | Number of independent replicate simulations per parameter combination. |
| `parameter_steps` | `Int` | Number of incremental steps along the sweep axis. |
| `sweep_parameter` | `String` | Name of the parameter to sweep over. Must match a key in `settings`. |
| `parameter_increment` | `Float64` | Additive increment applied to `sweep_parameter` at each step. |
| `sampling_interval` | `Float64` | Interval in seconds (simulation time) at which the model state is sampled and saved. |

**Example:** with `iterations = 5`, `parameter_steps = 3`, and `sweep_parameter = "growth_rate"`, the sweep produces 3 × 5 = 15 simulations in total, covering three growth rate values each replicated five times.

#### Physical model parameters

These correspond to fields of `parameters_physical` and carry physical units. They are extracted from `settings` by `create_para_struct` and `remove_fields_dict!` before constructing the parameter struct.

| Field | Example value | Description |
|---|---|---|
| `N` | `(1000, 1000)` | ABM grid dimensions (number of grid cells in x and y). |
| `L` | `(0.015, 0.015)` | Physical system size in metres (x, y). |
| `scale_fac` | `4` | Gradient grid scaling factor s_f relative to ABM grid. |
| `total_time` | `40900.0` | Total simulation time in seconds. |
| `agent_number` | `250000` | Initial number of agents. |
| `walker_speed_phy` | `5e-6` | Mean agent speed in m/s. |
| `Diff_coe` | `7e-11` | Diffusion coefficient of the chemical field in m²/s. |
| `walker_step_size` | `3` | Mean number of ABM grid cells traversed per agent time step. |
| `decay_rate` | `0.001` | Decay rate d_r of the chemical field. |
| `adsorption_rate` | `0.00001` | Adsorption rate a_d of the chemical field per agent. |
| `Diameter_colony` | `0.003` | Initial colony diameter in metres. |
| `growth_rate` | derived | Per-agent probability of division per agent time step (derived from doubling time; see below). |
| `noise_strength` | `0.2` | Standard deviation η of the orientational noise. |
| `velo_var_relative` | `1.5` | Relative standard deviation of the agent speed distribution. |
| `Δt_walker_min` | `0.1` | Minimum agent time step Δt_a in seconds. |
| `grid_strength` | `8000` | Initial boundary strength k₀. |
| `grid_recover_rate` | `7.0` | Rate at which boundary strength recovers between collisions. |
| `radius_collision` | `16` | Radius R_c (in ABM grid cells) of the boundary-weakening region upon collision. |
| `radius_tanget` | `15` | Radius R_t (in ABM grid cells) used to approximate the local boundary tangent. |

#### Deriving `growth_rate` from doubling time

The script illustrates the recommended way to convert a biological doubling time τ_d (in seconds) into the model growth rate:

```julia
doubling_time = 3600 * 9          # 9 h doubling time in seconds
growth_rate   = 2^(1/doubling_time) - 1
```

This corresponds to the formula r = 2^(1/τ_d) − 1 described in the model documentation. The script also shows how to define an increment for a growth-rate sweep by computing the difference between two biologically motivated doubling times (9 h and 20 h).

### Output folder and file naming

A uniquely named output folder is created automatically under `data_path` with the pattern:

```
<name>_<agent_number>_time_seed_<time_seed>/
```

where `<name>` is the user-defined run label (e.g. `"std_dev_test3_default_parameters"`), `<agent_number>` is taken directly from `settings`, and `<time_seed>` is a four-digit fragment of the Unix timestamp at launch, used to avoid name collisions between runs started on the same day.

The following files are written to this folder:

| File | Format | Description |
|---|---|---|
| `parameters.jls` | Julia serialisation | The fully constructed `parameters` struct for reimport into Julia. |
| `parameters.txt` | Plain text | Human-readable representation of the parameter struct. |
| `settings.jls` | Julia serialisation | The raw `settings` dictionary for reimport into Julia. |
| `settings.csv` | CSV | Human-readable representation of the settings dictionary. |
| `10000N` | `.jls` | One file per simulation where `N` is the number of simulations determined by iterations * parameter_steps , written by `sweep_and_save_parallel_t`. Such a file contains the parameter struct defining the simulation and the agent positions, directions, ABM grid and gradient grid for each sampled timepoint. Depending on the amount of agents, sizes of the grids and sampled timepoints such files can become size in the gigabyte range. Take care to have enough system storage and memory on your computer. If the memory is not sufficient, try reducing the number of threads.  |

### Data path

The output location is determined by `find_data_path(local_data = false)`. Setting `local_data = true` stores data locally within the package folder; `local_data = false` uses a preconfigured external path (e.g. a separate data drive). This should be configured once for your system before running sweeps.

### Parallelisation

The sweep is executed by `sweep_and_save_parallel_t`, which distributes individual simulations across Julia threads. By default, the script uses half the available threads:

```julia
threads2 = round(Int, Threads.nthreads() / 2)
sweep_and_save_parallel_t(para_dict_list, full_data_path, threads = threads2)
```

The other half of  the threads is used to calculate the diffusion in the simulated systems.  Launch Julia with multiple threads via:

```bash
julia --threads N sweep_parallel.jl
```

where `N` is the desired thread count (e.g. `--threads auto` to use all available cores).

### Run database

After each completed sweep, run metadata is appended to a persistent database stored in `data_base/df.jls` (and mirrored as `data_base/df.csv`). This allows you to track all past runs without manually inspecting folder names. The following fields are added to the database entry:

| Field | Description |
|---|---|
| `path` | Absolute path to the output folder. |
| `name` | User-defined run label. |
| `date` | Human-readable datetime of the run. |
| `unix_date` | Unix timestamp of the run (for precise sorting). |
| `run_time` | Total wall-clock time of the sweep in seconds. |
| `storage` | Disk space used by the output folder. |
| `location` | Base data path used for this run. |

All other fields from `settings` (parameters, sweep configuration) are also preserved in the database row. If the database does not exist, it will be initialised in the first run as an empty DataFrame and serialised to `data_base/df.jls`.

### Loading results

Simulation output files and the parameter struct can be reimported into Julia using the notebooks `load_data.ipynb`:

## `load_data.ipynb`

This notebook is the primary post-processing workflow for analysing simulation outputs produced by `sweep_parallel.jl`. It loads previously saved `.jls` files, computes derived metrics, and creates publication-style figures (heatmaps and time series) that are saved to each run's `analysis/` folder.

Unlike the interactive notebook, this workflow is data-driven: it does not run a new simulation. Instead, it reads trajectories and fields from disk and applies analysis functions to selected subsets of runs.

### Overview of the workflow

1. Activate the project environment and load plotting/data dependencies.
2. Select the data location (`local_data = true/false`) and load the run database (`data_base/df.jls`).
3. Filter the database to the selected storage location and choose one run (`data_used`).
4. Build a vector of file paths to simulation output (`create_data_path_vector`).
5. Explore single-run snapshots (heatmaps over time).
6. Compare parameter steps within one sweep.
7. Compute and visualise derived metrics (area gain, cell growth, adsorption, roughness, order metrics).
8. Save generated figures into `<run_path>/analysis/...`.

### Data selection and run metadata

The first cells load the persistent run table and derive helper columns (for example, `doubling_time` from `growth_rate`). A typical sequence is:

- Resolve data location with `find_data_path(local_data = false)`.
- Load `data_base/df.jls` and filter rows by `location`.
- Select one run row into `data_used`.

From `data_used`, the notebook reads key sweep metadata (e.g. `sweep_parameter`, `parameter_steps`, `iterations`, `sampling_interval`, `total_time`) that determine which files are loaded and how plots are labelled.

### Path handling and indexing

`create_data_path_vector(data_used.path)` creates the nested file-path list used throughout the notebook. Individual simulation files are accessed with helper indexing, e.g.:

```julia
it = index(iteration = 1, parameter_step = 1, parameter = data_used)
data = s.deserialize(path_vec[1][it])
```

Each loaded `data` object contains sampled time series of:

- agent state,
- ABM occupancy/boundary grids,
- gradient/concentration grids,
- and the parameter struct used for that run.

### Single-iteration visual inspection

The "One iteration" block plots a sequence of heatmaps from one simulation over selected time points. It overlays:

- colony occupancy/boundary image (`b_w_im(...)`, grayscale), and
- chemical/field grid (`viridis`, semi-transparent).

This section is useful for quickly checking whether one replicate behaves as expected before aggregating across the full sweep.

### Sweep comparison plots

The "Compare data in one sweep" section iterates over parameter steps and renders a panel of final-time heatmaps. Titles are automatically generated from the swept parameter value, which is reconstructed from base value plus increment.

This gives a qualitative map of morphology changes as the sweep parameter varies.

### Derived metric analysis

Subsequent sections compute and visualise derived quantities from `transform_data(data)` outputs, including:

- relative colony area increase (`area_gain`),
- adsorbed material (`adsorbed_material`),
- relative cell number increase (`cell_gain`),
- angular distribution metrics (`angular_metric`),
- pair-correlation-derived metrics (`pair_cor_metric`),
- roughness (`roughness`),
- Fourier mode metric (`fourier_ik`).

The notebook preallocates vectors for each metric and fills them in threaded loops over selected parameter points.

### Parallel metric computation

Metric extraction blocks use `Threads.@threads` to process multiple simulation files concurrently. This is independent of the original simulation threading and can significantly reduce analysis time when many parameter points or replicates are selected.

### Figures and outputs

Figures are generated with GLMakie and saved via `save(...)` into run-specific analysis folders, for example:

- `analysis/single/heatmap_...png`
- `analysis/<parameter>_..._only_heat_all.png`
- `analysis/<parameter>_..._area_adsorbed.png`
- `analysis/<parameter>_..._area__cells_adsorbed.png`
- `analysis/roughness_all.png`

Most figure cells also call `display(figX)` so results appear inline while running the notebook.

### Practical notes

- Ensure `path_vec`, `para_range`, and `data_r` are regenerated after changing `data_used`.
- Large sweeps can produce very large `.jls` files; keep an eye on memory when loading many runs at once.
- If analysis loops are slow, reduce `para_range` first, validate plotting logic on a small subset, then scale up.
- Some metrics intentionally skip earliest time points to avoid unstable ratios when means are near zero.

Together, these cells provide a complete path from raw simulation output files to comparative visual analytics across parameter sweeps.


