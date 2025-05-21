filename = 'archimedes_data.txt';
fid = fopen(filename, 'r');

% Skip header
fgetl(fid);

archimedesData = struct('ID', {}, 'Name', {}, 'Do', {}, 'H', {}, 'Q', {}, 'P', {}, 'Ref', {});

lineIndex = 1;
while ~feof(fid)
    line = strtrim(fgetl(fid));
    if isempty(line)
        continue;
    end
    
    % Split by spaces or tabs
    tokens = regexp(line, '\s+', 'split');

    % First token = ID
    ID = str2double(tokens{1});
    
    % The tricky part: find where numeric fields start
    % This will be the first token (after ID) that can be parsed as a number
    nameTokens = {};
    for i = 2:length(tokens)
        if ~isnan(str2double(tokens{i}))  % Number found
            firstNumIndex = i;
            break;
        else
            nameTokens{end+1} = tokens{i};
        end
    end
    
    % Extract name and numeric values
    Name = strjoin(nameTokens, ' ');
    Do = str2double(tokens{firstNumIndex});
    H = str2double(tokens{firstNumIndex + 1});
    Q = str2double(tokens{firstNumIndex + 2});
    P = str2double(tokens{firstNumIndex + 3});
    
    % Everything after that is reference
    Ref = strjoin(tokens(firstNumIndex + 4:end), ' ');

    % Store in structure
    archimedesData(lineIndex).ID = ID;
    archimedesData(lineIndex).Name = Name;
    archimedesData(lineIndex).Do = Do;
    archimedesData(lineIndex).H = H;
    archimedesData(lineIndex).Q = Q;
    archimedesData(lineIndex).P = P;
    archimedesData(lineIndex).Ref = Ref;

    lineIndex = lineIndex + 1;
end

fclose(fid);

% Display the first entry to check
disp(archimedesData(1))
