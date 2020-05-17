# earlyFIT
earlyFIT is an Octave framework to fit an ensemble of epidemic models to one or multiple regions at once. The name stems from the fact that it is suited to fit epidemic models in the early outbreak phase, when little data is available. I also wanted to avoid any obvious reference to the 2019-2020 pandemic in the name.

To use it, just edit and launch the earlyFIT.m script, which should be commented enough to be self-descriptive. The script should be easily adaptable to MATLAB, but no attempt has been made at this and there certainly are at least a couple of Octave function calls that need to be replaced with something else in MATLAB.

The idea behind the tool is to fit an ensemble of models to one or multiple regions at once. Data can be imported from one of multiple online sources or from a given file, while the following models are available for the fitting:

1. Exponential (Regular and Generalized)
2. Logistic (Regular and Generalized)
3. Gompertz (Regular and Generalized)
4. Richards (Regular and Generalized)
5. Sub-wave (based on Generalized Richards)
6. SIR (Regular and with non homogeneous mixing)
7. SEIR
8. SEmInR (a SIR/SEIR generalization to Erlang distributed times)

where the Generalized versions of the models 1-4 allow for early sub-exponential growth. User functions can be used to modify the growth rate (r) or the transmission rate (beta), according to the specific model in use (but some models don't allow this).

For each region in the data, the user selected models (one or more) will be first fitted to the current data and later refitted to a given number of bootstrapped samples (built using the previous fit and one of the three available error structures: Binomial, Poisson or Negative Binomial). For R regions, S models and M bootstrapped samples, the script will make RS(1+M) fittings and produce RM^S bootstrapped curves. The final ensemble for each region is built by weighting each of the M^S curves according to one of three possible criterions (Akaike, RMS or equal weights). Extrapolations of the fit (or "forecasts") are built in the same way. In both cases, confidence intervals are built from the given ensemble of curves.

An Octave/MATLAB implementation has been favoured (with respect to, say, one in C++ using [Ceres](https://github.com/ceres-solver/ceres-solver)) in order to keep everything simple and understandable to anyone. For the same reason, only matrices and cells are used, in place of more complicated data structures that could have made the code better conceived from the programming point of view. The main result is that some parts are not really fast and others are just written in a way that leads to inefficient execution. Editing is also longer, but everything is kept at a very simple level.

The following references have been used as inspiration for ideas and implementation:

* P. Yan, G. Chowell: Quantitative Methods for Investigating Infectious Disease Outbreaks, 2019, Springer

* G. Chowell: Fitting dynamic models to epidemic outbreaks with quantiﬁed uncertainty: A primer for parameter uncertainty, identiﬁability, and forecasts, Infectious Disease Modelling 2, 2017

* G. Chowell, R. Luo, K. Sun, K. Roosa, A. Tariq, C. Viboud: Real-time forecasting of epidemic trajectories using computational dynamic ensembles, Epidemics 30, 2020

* J. Ma: Estimating epidemic exponential growth rate and basic reproduction number, Infectious Disease Modeling 5, 2020

* S. Portet: A primer on model selection using the Akaike Information Criterion, Infectious Disease Modeling 5, 2020

* G. Chowell, A. Tariq, J.M. Hyman: A novel sub-epidemic modeling framework for short-term forecasting epidemic waves, BMC Medicine 17:164, 2019

* C. Viboud, L. Simonsen, G. Chowell: A generalized-growth model to characterize the early ascending phase of infectious disease outbreaks, Epidemics 15, 2016

* G. Chowell, C. Viboud, L. Simonsen, SM. Moghadas: Characterizing the reproduction number of epidemics with early subexponential growth dynamics, J. R. Soc. Interface 13, 2016

* R. Burger, G. Chowell, L. Yissedt Lara-Diaz: Comparative analysis of phenomenological growth models applied to epidemic outbreaks, MBE 16(5), 2019

* D. Champredon, J. Dushoff, D.J.D. Earn: Equivalence of the Erlang-distributed SEIR epidemic model and the renewal equation, SIAM J. APPL. MATH. Vol. 78, No. 6, 2018

* V. Capasso, G. Serio: A Generalization of the Kermack-McKendrick Deterministic Epidemic Model, MATHEMATICAL BIOSCIENCES 42, 1978

* W. Liu, S.A. Levin, Y. Iwasa: Influence of nonlinear incidence rates upon the behavior of SIRS epidemiological models, J. Math. Biology 23, 1986

* N. Bacaër, X. Abdurahman: Resonance of the epidemic threshold in a periodic environment, J. Math. Biol. 57, 2008

* R. Pearl and L.J. Reed: A Further Note on the Mathematical Theory of Population Growth, PNAS, 1922 8(12)

* C.P. Winsor: The Gompertz Curve as a Growth Curve, PNAS, 1932 18(1)

* K.M.C. Tjørve, E. Tjørve: The use of Gompertz models in growth analyses, and new Gompertz-model approach: An addition to the Unified-Richards family, PLoS ONE 12(6), 2017

* K.M.C. Tjørve, E. Tjørve: A proposed family of Uniﬁed models for sigmoidal growth, Ecological Modelling 359, 2017

