# earlyFIT
earlyFIT is an Octave framework to fit an ensemble of epidemic models to one or multiple regions at once. The name stems from the fact that it is suited to fit epidemic models in the early outbreak phase, when little data is available. I also wanted to avoid any obvious reference to the 2019-2020 pandemic in the name.

To use it, just edit and launch the `earlyFIT.m` script, which should be commented enough to be self-descriptive. The script should be easily adaptable to MATLAB, but no attempt has been made at this and there certainly are at least a couple of Octave function calls that need to be replaced with something else in MATLAB.

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

For each region in the data, the user selected models (one or more) will be first fitted to the current data and later refitted to a given number of bootstrapped samples (built using the previous fit and one of the three available error structures: Binomial, Poisson or Negative Binomial). For R regions, S models and M bootstrapped samples, the script will make RS(1+M) fittings and produce RM^S bootstrapped curves. For each region, the M^S curves are built by collecting each of the MS curves, S at once, where each of the S curves (i.e., each model) is weighted according to one of three possible criterions (Akaike, RMS or equal weights). Extrapolations of the fit (or "forecasts") are built in the same way. In both cases, confidence intervals are built from the given ensemble of curves (i.e., at each time an ensemble of M^S values will be available and used to build confidence intervals).

An Octave/MATLAB implementation has been favoured (with respect to, say, one in C++ using [Ceres](https://github.com/ceres-solver/ceres-solver)) in order to keep everything simple and understandable to anyone. For the same reason, only matrices and cells are used, in place of more complicated data structures that could have made the code better conceived from the programming point of view. The main result is that some parts are not really fast and others are just written in a way that leads to inefficient execution. Editing is also longer, but everything is kept at a very simple level.

# How to modify the code
The code has been developed to allow a certain set of relatively simple modifications

## Data input and pre-processing
Functions `load_data` and `pre_process` contain, respectively, several examples of data import and manipulation methods. You can just add your own using the available ones as examples.

## Initial parameter values and bounds
For each of the available models, you can use the function `model_param` to provide initial values and bounds for the model parameters, including fixing some of them by using equal values for the bounds. This step is not strictly necessary because an internal routine is used to taste several initial values before the fitting, but won't certainly hurt if realistic values are available.

However, if an user function is used, this step is mandatory for the parameters entering the user function.

## Adding/editing a model or user function
When editing or adding a model or an user function, you need to edit the following functions together: `model_param`, `from_guess_to_param`, `growth_model`, `user_functions`. This should be relatively straightforward considering the examples given by previous models and user functions.

# Known issues and missing features
* The fitting is relatively slow for models relying on one or more ODE, and even more so when the number of parameters is relatively high. There is really nothing you can do about it, except maybe switching to Fortran/C++ (I don't know, at the moment, if running in MATLAB might be any faster than Octave). Of course, this has a real impact only when you have a large number of models, regions and/or bootstrapping samples.

* Taking statistics from the ensemble of curves has been programmed with a certain model in mind and to avoid memory bottlenecks. This has led to a slow implementation (again, this wouldn't be the case in a compiled language). Still, this only becomes a problem if the overall number of curves in the ensemble is relevant.

* Ideally, every final quantity should be obtained from the ensemble of curves. At the moment only the cumulative incidence and its confidence interval is obtained in this way (because of the problems in 2), while some derived quantities (like the incidence rate) are nonetheless plotted in output. This can be corrected easily, but will have a cost in terms of memory and computing time.

* The method used to estimate the index of dispersion is pretty naive and you might want to improve on that. Still, its impact is relatively low and the current method just seems to work.

* There is no computation of basic or effective reproduction numbers. This is because of several reasons: a) each model has its own definitions, which would have implied an additional routine to modify when changing adding models; b) estimates based on the incidence rate (i.e., independent from the model) also require an hypothesis on the serial interval distribution, which is a piece of information that is outside the scope of the present framework; c) they really give no additional information with respect to the fitted and extrapolated curves; d) again, this should come out from the ensemble part as well, leading to additional memory and time issues.

* There is no output on parameters statistics and very few plots at all. However, the data is saved to file and can be further analyzed at will.

# References

The following references have been used as inspiration for ideas and implementation:

1. P. Yan, G. Chowell: *Quantitative Methods for Investigating Infectious Disease Outbreaks*, 2019, Springer

2. G. Chowell: *Fitting dynamic models to epidemic outbreaks with quantiﬁed uncertainty: A primer for parameter uncertainty, identiﬁability, and forecasts*, Infectious Disease Modelling 2, 2017

3. G. Chowell, R. Luo, K. Sun, K. Roosa, A. Tariq, C. *Viboud: Real-time forecasting of epidemic trajectories using computational dynamic ensembles*, Epidemics 30, 2020

4. J. Ma: *Estimating epidemic exponential growth rate and basic reproduction number*, Infectious Disease Modeling 5, 2020

5. S. Portet: *A primer on model selection using the Akaike Information Criterion*, Infectious Disease Modeling 5, 2020

6. G. Chowell, A. Tariq, J.M. Hyman: *A novel sub-epidemic modeling framework for short-term forecasting epidemic waves*, BMC Medicine 17:164, 2019

7. C. Viboud, L. Simonsen, G. Chowell: *A generalized-growth model to characterize the early ascending phase of infectious disease outbreaks*, Epidemics 15, 2016

8. G. Chowell, C. Viboud, L. Simonsen, SM. Moghadas: *Characterizing the reproduction number of epidemics with early subexponential growth dynamics*, J. R. Soc. Interface 13, 2016

9. R. Burger, G. Chowell, L. Yissedt Lara-Diaz: *Comparative analysis of phenomenological growth models applied to epidemic outbreaks*, MBE 16(5), 2019

10. D. Champredon, J. Dushoff, D.J.D. Earn: *Equivalence of the Erlang-distributed SEIR epidemic model and the renewal equation*, SIAM J. APPL. MATH. Vol. 78, No. 6, 2018

11. V. Capasso, G. Serio: *A Generalization of the Kermack-McKendrick Deterministic Epidemic Model*, MATHEMATICAL BIOSCIENCES 42, 1978

12. W. Liu, S.A. Levin, Y. Iwasa: *Influence of nonlinear incidence rates upon the behavior of SIRS epidemiological models*, J. Math. Biology 23, 1986

13. N. Bacaër, X. Abdurahman: *Resonance of the epidemic threshold in a periodic environment*, J. Math. Biol. 57, 2008

14. R. Pearl and L.J. Reed: *A Further Note on the Mathematical Theory of Population Growth*, PNAS, 1922 8(12)

15. C.P. Winsor: *The Gompertz Curve as a Growth Curve*, PNAS, 1932 18(1)

16. K.M.C. Tjørve, E. Tjørve: *The use of Gompertz models in growth analyses, and new Gompertz-model approach: An addition to the Unified-Richards family*, PLoS ONE 12(6), 2017

17. K.M.C. Tjørve, E. Tjørve: *A proposed family of Uniﬁed models for sigmoidal growth*, Ecological Modelling 359, 2017
