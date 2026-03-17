## TrypColonies.jl
[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://AndreasKuhn-ak.github.io/TrypColonies.jl/dev/)
[![Build Status](https://github.com/AndreasKuhn-ak/TrypColonies.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/AndreasKuhn-ak/TrypColonies.jl/actions/workflows/CI.yml?query=branch%3Amaster)



TrypColonies.jl is a Julia package for an angent based simulation of Trypanosoma colonies. 
### Documentation

For detailed documentation, please visit the following links:

- [Documentation](https://AndreasKuhn-ak.github.io/TrypColonies.jl/dev/)

## How to Use

To get started with TrypColonies.jl, follow these steps:

1. **Download the Repository**: Clone or download the ColonyImages.jl repository from GitHub to your local machine.

   ```bash
   git clone https://github.com/AndreasKuhn-ak/TrypColonies.jl.git  
    ``` 
2. **Navigate to the Package Directory**:  Open a terminal and change directory to the ColonyImages.jl folder.
   ```bash
   cd TrypColonies
    ``` 
3. **Activate the Julia Environment**: Start Julia in the terminal and activate the package environment.
   ```bash
    julia  
      ``` 
   Within the Julia REPL, activate and instantiate the project:
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

5. **Necessary Packages**: To ensure that all scripts and Jupyter notebooks in this GitHub repository work correctly, you additionally need those two packages: IJulia (to use Julia inside Jupyter notebooks) and Revise (for a more comfortable workflow without constantly restarting the Julia kernel). We developed/used the provided notebooks only in VS Code together with the Julia language extension, so we can only guarantee that they work there without problems. 
   ```julia
      using Pkg
      Pkg.add("IJulia")
      Pkg.add("Revise")
   ```



### Contributing

Contributions to TrypColonies.jl are welcome! If you encounter any issues, have suggestions for improvements or want to use TrypColonies in your work please open an issue on the [GitHub repository](https://github.com/AndreasKuhn-ak/TrypColonies.jl) or write me an message. 

### License

TrypColonies.jl is licensed under the MIT License. See the [LICENSE](https://github.com/AndreasKuhn-ak/TrypColonies.jl/blob/master/LICENSE) file for more details.
