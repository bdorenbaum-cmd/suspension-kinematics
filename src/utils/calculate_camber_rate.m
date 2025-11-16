function cambers = calculate_camber_rate(cambers)
midIdx = round(numel(cambers) / 2);     % middle row index
midCamber = cambers(midIdx);          % camber at the middle

cambers = cambers - midCamber;       % shift so middle becomes 0
end