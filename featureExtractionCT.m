function feat = featureExtractionCT(audio_signal)

shiftFB = estimateTuning(audio_signal);

paramPitch.winLenSTMSP = 4410;
paramPitch.shiftFB = shiftFB;
paramPitch.visualize = 0;
[f_pitch,sideinfo] = ...
    audio_to_pitch_via_FB(audio_signal,paramPitch);

% paramCP.applyLogCompr = 0;
% paramCP.visualize = 0;
% paramCP.inputFeatureRate = sideinfo.pitch.featureRate;
% [f_CP,sideinfo] = pitch_to_chroma(f_pitch,paramCP,sideinfo);

paramCLP.applyLogCompr = 1;
paramCLP.factorLogCompr = 100;
paramCLP.visualize = 0;
paramCLP.inputFeatureRate = sideinfo.pitch.featureRate;
[f_CLP,sideinfo] = pitch_to_chroma(f_pitch,paramCLP,sideinfo);

% paramCENS.winLenSmooth = 21;
% paramCENS.downsampSmooth = 5;
% paramCENS.visualize = 0;
% paramCENS.inputFeatureRate = sideinfo.pitch.featureRate;
% [f_CENS,sideinfo] = pitch_to_CENS(f_pitch,paramCENS,sideinfo);

paramCRP.coeffsToKeep = [55:120];
paramCRP.visualize = 0;
paramCRP.inputFeatureRate = sideinfo.pitch.featureRate;
[f_CRP,sideinfo] = pitch_to_CRP(f_pitch,paramCRP,sideinfo);

% paramSmooth.winLenSmooth = 21;
% paramSmooth.downsampSmooth = 5;
% paramSmooth.inputFeatureRate = sideinfo.CRP.featureRate;
% [f_CRPSmoothed, featureRateSmoothed] = ...
%     smoothDownsampleFeature(f_CRP,paramSmooth);
% %parameterVis.featureRate = featureRateSmoothed;
% %visualizeCRP(f_CRPSmoothed,parameterVis);

feat = [mean(f_pitch,2)' mean(f_CLP,2)' mean(f_CRP,2)'];

end