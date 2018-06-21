clear 

w = 0.85;

R = 1;                      %transmission rate in bits/slot (same for every SBS)
B = 1;                      %size of videos
K = 10000;                  %number of videos considered
Vunsrt = zipf(K, w);        %probabilities of videos
V = sort(Vunsrt, 'descend')';

N = 100;                    %number of picocells or SBSs
T_max = 10;                 %threshold delay to ensure fairness
C = 4000;


%% Test 1
[ gamma, GAMMA, DLstar ] = preprocess( V, T_max );

Mk1 = delayAwareAlgorithm( V, DLstar, GAMMA, gamma, C );
Mk2 = mpfc_delayMin( C, T_max, K);
Mk3 = efc_delayMin( C, T_max, gamma, K );

'Test 1 PASSED'

%% Test 2
C = 800; 

Vunsrt = zipf(K, w);        %probabilities of videos
p = sort(Vunsrt,'descend')';

a = 1;                      %users' mobility status - purely mobile 
T_avg = 6;                  %threshold average delay to ensure quality

[ results, Mk4 ] = delayConstrCostMinimMob( Vunsrt, p, C, B, T_max, T_avg, a );
[ results, Mk5 ] = mpfc_costMin( C, T_max, T_avg, p, Vunsrt, a );
[ results, Mk6 ] = efc_costMin( Vunsrt, p, C, B, T_max, T_avg, a );

'Test 2 PASSED'


%% Test 3

K = 1000;                  %number of videos considered
Vunsrt = zipf(K, w);        %probabilities of videos
V = sort(Vunsrt, 'descend')';

N = 100;                    %number of picocells or SBSs
T_max = 10;                 %threshold delay to ensure fairness
alpha = 0.7;
T_avg = 2;

C = 50;

[ results1, Mk7 ] = delayConstrCostMinimGenMob( V, C, T_max, T_avg, alpha );
[ results2, Mk8 ] = mpfc_costMin( C, T_max, T_avg, V, Vunsrt, alpha );
[ results3, Mk9 ] = efc_costMin( Vunsrt, V, C, B, T_max, T_avg, alpha );

'Test 3 PASSED'

%% Test 4

K = 1000;                  %number of videos considered
Vunsrt = zipf(K, w);        %probabilities of videos
V = sort(Vunsrt, 'descend')';

N = 100;                    %number of picocells or SBSs
T_max = 10;                 %threshold delay to ensure fairness
alpha = 0.7;
T_avg = 2;

C = 50;

            Mk10   = delayConstrFreeCostMinim( V, C, T_max, alpha );
[ results2, Mk11 ] = mpfc_costMin( C, T_max, T_avg, V, Vunsrt, alpha );
[ results3, Mk12 ] = efc_costMin( Vunsrt, V, C, B, T_max, T_avg, alpha );

'Test 4 PASSED'

