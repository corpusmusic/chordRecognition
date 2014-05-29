function data = getData( filename, songList )
% filename is the path of all_chords.csv
% songList is a vector with the song indices to extract information from
% data outputs the song index, start time, end time and chord ID.

M = importdata(filename);
nSamples = 0;
for i = 2: 255214 %length(M)
    temp = strsplit(M{i},',');
    if ~isempty(find(songList == str2num(temp{1}))) 
        nSamples = nSamples + 1;
        d(nSamples,:) = [temp(1) temp(2) temp(8) temp(12)];
    end
end 

% Now clean the data

cSamples = 0;
for i = 1: nSamples
    if strcmp(d(i,3),'NA') == 0
        if strcmp(d(i,4),'maj') == 1 || strcmp(d(i,4),'min') == 1 
            if strcmp(d(i,1),d(i+1,1)) == 1 %% if next sample corresponds to the same song
                cSamples = cSamples + 1;
                data(cSamples,:) = [str2num(cell2mat(d(i,1))) str2num(cell2mat(d(i,2))) str2num(cell2mat(d(i+1,2))) str2num(cell2mat(d(i,3)))];
                if strcmp(d(i,4),'min') == 1
                    if data(cSamples,4) == 4 %% it's Emin --> 13
                        data(cSamples,4) = 13;
                    else
                        data(cSamples,4) = data(cSamples,4) + 1;    
                    end
                end
            end
        end
    end
end

end
