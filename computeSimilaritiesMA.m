function D = computeSimilarities(feat)
%%
%%         G1C, implementation as described in thesis
%%         for mirex, "music audio search" (was audio music similarity)
%%
%%
%% INPUT ARGUMENTS
%%
%%     Q\R   1       2      ...      N
%%     1     0.000  10.234  ...   123.32
%%     2    10.234   0.000  ...    23.45
%%     .     ...     ...    0.000   ...
%%     N     4.1234  6.345  ...     0.0

Ns = length(feat);
D = zeros(Ns,Ns);

for i=1:Ns-1,
    for j=i+1:Ns,
        d_g1_computed = false;
        if all([feat(i).g1c.max_ico,feat(j).g1c.max_ico]<10^10),
            tmp = squeeze(feat(i).g1.m)-squeeze(feat(j).g1.m);
            d_g1 = ... %% kl distance
                trace(squeeze(feat(i).g1.co)*squeeze(feat(j).g1.ico)) + ...
                trace(squeeze(feat(j).g1.co)*squeeze(feat(i).g1.ico)) + ...
                trace((squeeze(feat(i).g1.ico)+squeeze(feat(j).g1.ico))*tmp*tmp');
            d_g1_computed = true;
        end
        d_fp = norm(feat(i).fp-feat(j).fp);
        d_fpg = abs(feat(i).fpg-feat(j).fpg);
        d_fpb = abs(feat(i).fp_bass-feat(j).fp_bass);

        if d_g1_computed,
            D(i,j) = ...
                0.7*(-exp(-1/450*d_g1)+0.7950)/0.1493 + ...
                0.1*(d_fp-1688.4)/878.23 + ...
                0.1*(d_fpg-1.2745)/1.1245 + ...
                0.1*(d_fpb-1064.8)/932.79 + ...
                10; %% ensure all values larger than one (+1.5 should be enough in most cases)
        else %% not evaluated work around to deal with inv covariance problems
            D(i,j) = ...
                0.4*(d_fp-1688.4)/878.23 + ...
                0.3*(d_fpg-1.2745)/1.1245 + ...
                0.3*(d_fpb-1064.8)/932.79 + ...
                10;
        end

    end        
end
D = D+D';
    
