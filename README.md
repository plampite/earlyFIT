# earlyFIT
earlyFIT is an Octave framework to fit an ensemble of epidemic models to one or multiple regions at once. The name stems from the fact that it is suited to fit epidemic models in the early outbreak phase, when little data is available. I also wanted to avoid any obvious reference to the 2019-2020 pandemic in the name.

To use it, just edit and launch the earlyFIT.m script, which should be commented enough to be self-descriptive. The script should be easily adapted to MATLAB, but no attempt has been made and there certainly are a couple of Octave function calls that need to be replaced in MATLAB.

The idea behind the tool is to fit an ensemble of models to one or multiple regions at once. Data can be imported from one of multiple online sources or from a given file, while the following models are available for the fitting:

1. Exponential (Regular and Generalized)
2. Logistic (Regular and Generalized)
3. Gompertz (Regular and Generalized)
4. Richards (Regular and Generalized)
5. Sub-wave (based on Generalized Richards)
6. SIR (Regular and with non homogeneous mixing)
7. SEIR
8. SEmInR (a SIR/SEIR generalization to Erlang distributed times)

where the Generalized versions of the models 1-4 allow for early sub-exponential growth.

For each region in the data, the user selected models (one or more) will be first fitted to the current data and later refitted to a given number of bootstrapped samples (built using one of three available error structures: Binomial, Poisson or Negative Binomial). For R regions, S models and M bootstrapped samples, the script will make RS(1+M) fittings and produce RM^S bootstrapped curves.

The main references are:

* P. Yan, G. Chowell: Quantitative Methods for Investigating Infectious Disease Outbreaks, 2019, Springer

* G. Chowell: Fitting dynamic models to epidemic outbreaks with quantiﬁed uncertainty: A primer for parameter uncertainty, identiﬁability, and forecasts, Infectious Disease Modelling 2, 2017

* G. Chowell, R. Luo, K. Sun, K. Roosa, A. Tariq, C. Viboud: Real-time forecasting of epidemic trajectories using computational dynamic ensembles, Epidemics 30, 2020

* J. Ma: Estimating epidemic exponential growth rate and basic reproduction number, Infectious Disease Modeling 5, 2020

* S. Portet: A primer on model selection using the Akaike Information Criterion, Infectious Disease Modeling 5, 2020

* G. Chowell, A. Tariq, J.M. Hyman: A novel sub-epidemic modeling framework for short-term forecasting epidemic waves, BMC Medicine 17:164, 2019

* R. Pearl and L.J. Reed: A Further Note on the Mathematical Theory of Population Growth, PNAS, 1922 8(12)

* C.P. Winsor: The Gompertz Curve as a Growth Curve, PNAS, 1932 18(1)

* K.M.C. Tjørve, E. Tjørve: The use of Gompertz models in growth analyses, and new Gompertz-model approach: An addition to the Unified-Richards family, PLoS ONE 12(6), 2017

* K.M.C. Tjørve, E. Tjørve: A proposed family of Uniﬁed models for sigmoidal growth, Ecological Modelling 359, 2017

