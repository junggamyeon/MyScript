local whitelist = {
    3732374542, -- Fernandin
    3010216570, -- ySanemi
    2831675278, -- Viktin
    3553830240, -- Mathzinzx
    638931134, -- Zekyu
    1200950760, -- Campos
    2587670881, -- Toshiro
    1929906784, -- Rafael
    283616063, -- Zenitsu
    558089552, 1823861246, -- Arthur Superior
    3304593429, -- John Cena
    3188512202, -- Sacolinha
    2038778847, -- Escuridão
    3067509017, -- WesleyPC
    3332872267, -- Lirous
    2504255348, -- DouglasNFT
    2771766988, -- Slow
    127184704, -- Senju
    3568641694, -- LhyMoDs
    2238617765, -- TheFox
    223770715, -- Jaca
    2427591310, 2231900218, -- Ninja
    113452795, -- Mudinho
    1934778943, 3735830398, -- Shonen
    1022210737, -- Luipy
    1340755305, 2375591157, 232422286 -- Mazter
}

local url = string.split(game.Players.LocalPlayer.CharacterAppearance, "=")
local userid = tonumber(url[#url])
if table.find(whitelist, userid) then
    return true
else
    return false
end
