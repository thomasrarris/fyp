function [ results, Mk ] = delayConstrCostMinimGenMob( V, CB, D_max, D_avg, alpha )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

    K = size(V,1);
    
    Mk = delayConstrFreeCostMinim( V, CB, D_max, alpha );
    
    results = zeros(K,2);

    count = 1;
    while getAvgDelay(K, Mk, V) > D_avg
        uncaching = V(Mk>0);
        partialcaching = V(Mk==1);
        
        candidate1 = size(uncaching,1);
        candidate2 = size(partialcaching,1);

        impact1 = alpha * V(candidate1);
        impact2 = inf;
        if candidate2 ~= 0 
            impact2 = (1-alpha) * V(candidate2);
        end
        
        
        if impact1 <= impact2
            Mk(candidate1) = 0;
            
            partiallyCachedTemp = V(and(Mk>0,Mk<1 ));
            
            [ gamma, GAMMA, DLstar ] = preprocess( partiallyCachedTemp, D_max );
            alloc = delayAwareAlgorithm( partiallyCachedTemp, DLstar, GAMMA, gamma, CB - sum(Mk==1) );
            Mk(sum(Mk==1)+1:sum(Mk~=0)) = alloc;
            
        else
             
            unCachedTemp = V(candidate2: candidate1);
            
            [ gamma, GAMMA, DLstar ] = preprocess( unCachedTemp, D_max );
            alloc = delayAwareAlgorithm( unCachedTemp, DLstar, GAMMA, gamma, CB - sum(Mk==1) + 1 );
            if alloc(1) == 1
                
                Mk(candidate1) = 0;
            
                partiallyCachedTemp = V(and(Mk>0,Mk<1 ));

                [ gamma, GAMMA, DLstar ] = preprocess( partiallyCachedTemp, D_max );
                alloc = delayAwareAlgorithm( partiallyCachedTemp, DLstar, GAMMA, gamma, CB - sum(Mk==1) );
                Mk(sum(Mk==1)+1:sum(Mk~=0)) = alloc;
                
            else
                Mk(candidate2: candidate1) = alloc;
            end
            
        end
        
        results(count,:) = [getAvgDelay(K, Mk, V) cost( K, V, Mk, alpha )];
        [getAvgDelay(K, Mk, V) cost( K, V, Mk, alpha )];
        count = count + 1;
        
    end
    
    results = results(results(:,1)>0,:);
end

