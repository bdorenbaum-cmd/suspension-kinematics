function P = get_kinematic_points()
%GETKINEMATICPOINTS Load front-suspension hardpoints from CSV into a KinematicsPoints object.

arguments (Output)
    P (1,1) KinematicsPoints
end

% --- Locate and read CSV
csvName = 'Points.csv';
baseDir = fileparts(mfilename('fullpath'));
csvPath = fullfile(baseDir, '..', '..', 'data', csvName);
if ~isfile(csvPath)
    error('getKinematicPoints:MissingCSV', ...
        'Could not find "%s" next to %s.m.', csvName, mfilename);
end

opts = detectImportOptions(csvPath, 'TextType', 'string');
opts.VariableNames = matlab.lang.makeValidName(opts.VariableNames);
T = readtable(csvPath, opts);

% --- Resolve required columns
vnLower = lower(string(T.Properties.VariableNames));
colFeature = firstMatch(T, vnLower, ["feature","name"]);
colX      = firstMatch(T, vnLower, "x");
colY      = firstMatch(T, vnLower, "y");
colZ      = firstMatch(T, vnLower, "z");

if isempty(colFeature)
    error('getKinematicPoints:BadCSV','CSV must contain a "Feature" or "Name" column.');
end
if any(cellfun(@isempty, {colX,colY,colZ}))
    error('getKinematicPoints:BadCSV','CSV must contain X, Y, and Z columns.');
end

% Pull columns and ensure numeric XYZ
FeatureName = string(T.(colFeature));
X = toNumeric(T.(colX));
Y = toNumeric(T.(colY));
Z = toNumeric(T.(colZ));

% --- Hardpoints
FUCO = getPoint("FUCA outboard",        FeatureName, X, Y, Z, csvName);
FUCF = getPoint("FUCA fore",            FeatureName, X, Y, Z, csvName);
FUCA = getPoint("FUCA aft",             FeatureName, X, Y, Z, csvName);

FLCO = getPoint("FLCA outboard",        FeatureName, X, Y, Z, csvName);
FLCF = getPoint("FLCA fore",            FeatureName, X, Y, Z, csvName);
FLCA = getPoint("FLCA aft",             FeatureName, X, Y, Z, csvName);

FTRO = getPoint("Front tie rod outboard", FeatureName, X, Y, Z, csvName);
FTRI = getPoint("Front tie rod inboard",  FeatureName, X, Y, Z, csvName);

FWC  = getPoint("wheel_center", FeatureName, X, Y, Z, csvName);

% --- Construct with name-value arguments
P = KinematicsPoints( ...
    FUCO = FUCO, ...
    FUCF = FUCF, ...
    FUCA = FUCA, ...
    FLCO = FLCO, ...
    FLCF = FLCF, ...
    FLCA = FLCA, ...
    FTRO = FTRO, ...
    FTRI = FTRI, ...
    FWC  = FWC, ...
    FWCP = [FWC(1) FWC(2) 0], ... % TODO: remove hardcoding
    RUCO = [NaN NaN NaN], ... % TODO: connect rear points
    RUCF = [NaN NaN NaN], ...
    RUCA = [NaN NaN NaN], ...
    RLCO = [NaN NaN NaN], ...
    RLCF = [NaN NaN NaN], ...
    RLCA = [NaN NaN NaN], ...
    RTRO = [NaN NaN NaN], ...
    RTRI = [NaN NaN NaN], ...
    RWC  = [NaN NaN NaN], ...
    RWCP = [NaN NaN NaN] ... 
);

end

% === Helpers ===
function name = firstMatch(T, vnLower, keys)
% Return the first column name from T whose *lowercased* name contains any key.
    if ~isscalar(keys)
        idx = contains(vnLower, keys(:)');
    else
        idx = contains(vnLower, keys);
    end
    if any(idx)
        name = string(T.Properties.VariableNames{find(idx,1,'first')});
    else
        name = string.empty;
    end
end

function xyz = getPoint(label, names, X, Y, Z, csvName)
% Return [x y z] for the row whose Feature/Name matches label (case-insensitive).
    lbl = strtrim(string(label));
    namesTrim = strtrim(names);
    idx = strcmpi(namesTrim, lbl);

    % If no exact match, try substring contains (case-insensitive)
    if ~any(idx)
        idx = contains(lower(namesTrim), lower(lbl));
    end

    if ~any(idx)
        % Build a short suggestions list
        uniqueNames = unique(namesTrim);
        nShow = min(numel(uniqueNames), 10);
        listStr = strjoin(uniqueNames(1:nShow), ', ');
        error('getKinematicPoints:LabelNotFound', ...
            'Label "%s" not found in %s. A few available names: %s%s', ...
            lbl, csvName, listStr, ternary(numel(uniqueNames)>nShow, ' ...', ''));
    end

    if nnz(idx) > 1
        warning('getKinematicPoints:AmbiguousLabel', ...
            'Multiple matches for "%s" in %s; using the first match.', lbl, csvName);
    end

    k = find(idx,1,'first');
    xyz = [X(k), Y(k), Z(k)];
end

function v = toNumeric(col)
% Convert a table column to numeric, handling string/cellstr gracefully.
    if isnumeric(col)
        v = double(col);
    elseif isstring(col)
        v = str2double(col);
    elseif iscellstr(col) || (iscell(col) && all(cellfun(@ischar,col)))
        v = str2double(string(col));
    else
        try
            v = double(col);
        catch
            error('getKinematicPoints:NonNumericXYZ', ...
                'X/Y/Z columns must be numeric or convertible to numeric.');
        end
    end
end

function out = ternary(cond, a, b)
% Simple ternary helper
    if cond, out = a; else, out = b; end
end