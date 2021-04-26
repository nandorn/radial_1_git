-- GCD függvény, mert a FEMM-es Lua ezt valamiért nem tudja a math könyvtárból (ahogy a modulo-t sem).
function gcd (a, b)
  while (b ~= 0) do
    temp = a - floor(a/b)*b -- a % b == a - math.floor(a/b)*b
    a = b
    b = temp
  end
  return(a);
end


function FEMM_arc_draw (r, alpha, gr)  -- TODO?
--     '''
--     FEMM körív rajzoló függvény.
--     Adott sugár és szög [radián] mellett felrajzol egy körívet, középpont: (0,0).
--     A rajzolt pontokat hozzáadja 'gr' grouphoz.
--     '''

    mi_addnode(r, 0)
    mi_addnode(r * cos(rad(alpha)), r * sin(rad(alpha)))

    mi_addarc(r, 0, r * cos(rad(alpha)), r * sin(rad(alpha)), alpha,
              1)  -- ?TODO? Lehet, hogy nem Yo.

    mi_clearselected()
    mi_selectnode(r, 0)
    mi_setgroup(gr)
    mi_clearselected()
    mi_selectnode(r * cos(alpha), r * sin(alpha))
    mi_setgroup(gr)
    mi_clearselected()
    mi_selectarcsegment(r, 0.1)
    mi_setgroup(gr)
    return
end


function FEMM_arc_draw_2 (r, alpha, gr)  -- TODO?
--     '''
--     Spéci FEMM körív rajzoló függvény: törli a végpontjait.
--     Adott sugár és szög [radián] mellett felrajzol egy körívet, középpont: (0,0).
--     A rajzolt pontokat hozzáadja 'gr' grouphoz.
--     '''

    mi_addnode(r, 0)
    mi_addnode(r * cos(rad(alpha)), r * sin(rad(alpha)))

    mi_addarc(r, 0, r * cos(rad(alpha)), r * sin(rad(alpha)), alpha,
                   1)  -- ?TODO? Lehet, hogy nem Yo.

    mi_clearselected()
    mi_selectnode(r, 0)
    mi_deleteselected()
    mi_clearselected()
    mi_selectnode(r * cos(rad(alpha)), r * sin(rad(alpha)))
    mi_deleteselected()
    return
end


function FEMM_rotate_point (ox, oy, px, py, o_rad)  -- TODO?
--     '''
--     Koordináta forgató függvény.
--     Adott P(px, py) pont koordinátáit
--     elforgatja egy tetszőleges O(ox, oy)
--     pont körül adott (o_rad) szöggel (radiánban).
--     Visszatér a koordinátákkal.
--     '''

    abs_p = sqrt(px^2 + py^2)
    p_rad = atan(px / py)

    px_rot = abs_p * sin(p_rad + o_rad) + ox
    py_rot = abs_p * cos(p_rad + o_rad) + oy

    return {px_rot, py_rot}
end


function FEMM_circle_draw (r, gr)
--     '''
--     Körív rajzoló függvény.
--     Paraméterei: (r sugár, gr groupnumber).
--     Egy (0,0) középpontú 'r' sugarú kört rajzol,
--     és hozzárendeli őket a 'gr' számú grouphoz.
--     '''

    mi_addnode(r, 0)
    mi_addnode(-r, 0)

    mi_addarc(r, 0, -r, 0, 180, 1)  --# -- külső körív felrajzolása
    mi_addarc(-r, 0, r, 0, 180, 1)

    mi_clearselected()
    mi_selectnode(r, 0)
    mi_setgroup(gr)
    mi_clearselected()
    mi_selectnode(-r, 0)
    mi_setgroup(gr)
    mi_clearselected()
    mi_selectarcsegment(r, 0.1)
    mi_setgroup(gr)
    mi_clearselected()
    mi_selectarcsegment(r, -0.1)
    mi_setgroup(gr)
    return
end


function make_prop_specs (Z, p, D, l_fog, b_fog, b_stat_kosz, b_rot_kosz, beta, m_mag)
--     '''
--     Konkrét gépparamétereket alakít át arányosságokra, melyek alapján felépíthető egy FEMM modell.
--     FEMM_radial_slice függvény bemenetére várja.
--     :param Z: horonyszám
--     :param p: pólusszám
--     :param D: furatátmérő
--     :param l_fog: foghossz
--     :param b_fog: fogszélesség
--     :param b_stat_kosz: állórészkoszorú vastagsága
--     :param b_rot_kosz:  forgórészkoszorú vastagsága
--     :param beta: mágnes kitöltése
--     :param m_mag: mágnes magassága
--     :return: ...
--     '''

    tau_p = (D * pi) / (2 * p)  -- - Pólusosztás
    tau_h = (D * pi) / Z  -- - Horonyosztás

    m_szel = tau_p * (beta / 180)  -- - Mágnes szélesség

    return Z, p, beta, b_fog/m_szel, b_fog/tau_h, l_fog/D, b_stat_kosz/D, b_rot_kosz/D, b_fog/tau_h, m_mag/D, m_mag/tau_p
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
showconsole()

print("script started")


-- path = filename .. ".fem"
-- open(path)
--
-- path_temp = filename .. "_tmp" .. ".fem"
-- mi_saveas(path_temp)
-- mi_close()
-- open(path_temp)


-- mi_clearselected()
-- for i=0, 1000, 1 do
--     mi_selectgroup(i)
-- end
-- mi_deleteselected()


-- változók: Z, p, filename
--'''Egy létező, éppen megnyitott FEMM fileba arányosságok alapján felrajzol a paramétereinek megfelelő gépszeletet (pizzaszelet), visszatér a szórással szórást.'''
D=100

for Z=z_min, z_max+1, 1 do
--     p=12
--     tau_h_for = (D * pi) / Z
--     b_fog=tau_h_for*0.25
--     l_fog=10
--     b_stat_kosz=3
--     b_rot_kosz=3
--     beta=120
--     m_mag=2

    if ((Z - floor(Z/3)*3) == 0)
    then


        for p=3, 25, 1 do

            if ((p > Z/4) and (p < Z*2/3))
            then

                tau_h_for = (D * pi) / Z  -- Horonyosztás
                for b_fog=tau_h_for*0.25, tau_h_for*0.6, tau_h_for*0.35/10 do -- nagy felbontással
                    for l_fog=10, 35, 6 do -- 2. prioritás
--                         for b_stat_kosz=3, 12, 6 do
--                             for b_rot_kosz=3, 12, 6 do -- átlagos remamenciával kiejteni (1.2-1.3T)
                                for beta=140, 170, 2 do -- 140-170: nagy felbontással
                                    for m_mag=1.5, 5, 1 do -- 2. prioritás

                                        --b_rot_kosz = (D/2 - 1 - m_mag) * sin((beta/2)*180 * pi/2) * (1.2/1.5) -- TODO!
                                        b_rot_kosz = (D * pi) / (2 * p) / 2 * (1.2/1.5) -- TODO!

                                        b_stat_kosz = b_rot_kosz


                                        path = filename .. ".fem"
                                        open(path)

                                        path_temp = filename .. "_tmp" .. ".fem"
                                        mi_saveas(path_temp)
                                        mi_close()
                                        open(path_temp)


                                        mi_clearselected()
                                        for i=0, 1000, 1 do
                                            mi_selectgroup(i)
                                        end
                                        mi_deleteselected()


                                        tau_p = (D * pi) / (2 * p)  -- - Pólusosztás
                                        tau_h = (D * pi) / Z  -- - Horonyosztás

                                        m_szel = tau_p * (beta / 180)  -- - Mágnes szélesség

                                        b_fogperm_szel = b_fog/m_szel
                                        b_fogpertau_p = b_fog/tau_h
                                        l_fogperd = l_fog/D
                                        b_stat_koszperd = b_stat_kosz/D
                                        b_rot_koszperd = b_rot_kosz/D
                                        b_fogpertau_h = b_fog/tau_h
                                        m_magperd = m_mag/D
                                        m_magpertau_p = m_mag/tau_p


                                        Z_modell = floor(Z)
                                        p_modell = floor(p)
                                        beta_modell = beta
                                        D_modell = 100  ---- - [mm] A FEMM modellben értelmezett fix furatátmérő, a többi adatot ehhez arányosítjuk.
                                        legres_modell = 0.5  ---- - [mm] légrés

                                        tau_p_modell = (D_modell * pi) / (2 * p_modell)  -- - Pólusosztás arányosan
                                        tau_h_modell = (D_modell * pi) / Z_modell  -- - Horonyosztás arányosan

                                        l_fog_modell = l_fogperd * D_modell  ---- - Foghossz arányosan
                                        b_fog_modell = b_fogpertau_h * tau_h_modell  -- - Fogszélesség arányosan

                                        b_stat_kosz_modell = b_stat_koszperd * D_modell  -- - Forgórészkoszorú vastagsága arányosan
                                        b_rot_kosz_modell = b_rot_koszperd * D_modell  -- - Forgórészkoszorú vastagsága arányosan

                                        m_mag_modell = m_magperd * D_modell  -- - Mágnes magasság arányosan

                                        LNKO = gcd(Z_modell, p_modell)  -- - Horony- és pólusszám legnagyobb közös osztója

                                        Z_modell_per = floor(Z_modell / LNKO)  -- - Egy szelet Z
                                        p_modell_per = floor(p_modell / LNKO)  -- - Egy szelet p

                                        if(LNKO<1 or b_fog_modell>tau_h_modell*0.85 or b_fog_modell<tau_h_modell*0.15)
                                        then
                                            return 0
                                        end

                                        -- - állórész felrajzolásához tartózóm szeletek, nem a teljes modell szelet!
                                        szelet_deg = 360 / Z_modell / 2
                                        szelet_rad = rad(szelet_deg)
                                        fog_rad = tan((b_fog_modell / 2) / (D_modell / 2))
                                        fog_deg = deg(fog_rad)
                                        horony_deg = szelet_deg - fog_deg
                                        horony_rad = rad(horony_deg)

                                        fogfejhossz = l_fog_modell * 0.15  -- Ez tetszőleges, a fogfej magasságát adja meg.

                                        r_furat = D_modell / 2
                                        r_belso = r_furat + l_fog_modell
                                        r_kulso = r_belso + b_stat_kosz_modell

                                        fogszelall = 1.7  -- fogszélességet állító állandó -- Z30-ra fogszelall=1.5 jó választás // minél nagyobb, annál kisebb a fogfej

                                        -- - Azért, hogy ne legyenek nagyon csúnya konstrukciók. (kis fogszélesség - nagy fogfej ellen)
                                        if(b_fog_modell < tau_h_modell/3)
                                        then
                                            fogszelall = 2.7
                                        end

                                        ---- -- Fogfej furathoz közelebbi pontja, "sarok".
                                        tmp_szog = asin((r_furat + fogfejhossz / 3) * sin(fog_rad + (szelet_rad - fog_rad) / fogszelall) / r_furat)
                                        point1 = {r_furat * cos(tmp_szog), r_furat * sin(tmp_szog)}  ---- -- [x, y] --? v2 - Fogfej vízszintes


                                        ---- -- Fogfej horony felőli pontja.
                                        point2 = {(r_furat + fogfejhossz / 3) * cos(fog_rad + (szelet_rad - fog_rad) / fogszelall),
                                                  (r_furat + fogfejhossz / 3) * sin(fog_rad + (szelet_rad - fog_rad) / fogszelall)}  -- ?

                                        ---- -- Fogfej 'tőpontja'.
                                        point3 = {(r_furat + fogfejhossz) * cos(fog_rad), (r_furat + fogfejhossz) * sin(fog_rad)}

                                        ---- -- Fogtő pontja.
                                        point4 = {r_belso * cos(asin(point3[2] / r_belso)), r_belso * sin(asin(point3[2] / r_belso))}

                                        ---- -- Horony tengely felőli pontja
                                        point5 = {(r_furat + fogfejhossz) * cos(szelet_rad), (r_furat + fogfejhossz) * sin(szelet_rad)}

                                        ---- -- Horony koszorú felőli pontja
                                        point6 = {r_belso * cos(szelet_rad), r_belso * sin(szelet_rad)}  -- ?

                                        -- -- Rajzolás

                                        mi_clearselected()

                                        mi_addnode(point1[1], point1[2])
                                        mi_selectnode(point1[1], point1[2])
                                        mi_setgroup(2)

                                        mi_addnode(point2[1], point2[2])
                                        mi_selectnode(point2[1], point2[2])
                                        mi_setgroup(2)

                                        mi_addnode(point3[1], point3[2])
                                        mi_selectnode(point3[1], point3[2])
                                        mi_setgroup(2)

                                        mi_addnode(point4[1], point4[2])
                                        mi_selectnode(point4[1], point4[2])
                                        mi_setgroup(2)

                                        mi_addnode(point5[1], point5[2])
                                        mi_selectnode(point5[1], point5[2])
                                        mi_setgroup(2)

                                        mi_addnode(point6[1], point6[2])
                                        mi_selectnode(point6[1], point6[2])
                                        mi_setgroup(2)


                                        mi_addsegment(point1[1], point1[2], point2[1], point2[2])
                                        mi_selectsegment(point1[1], point1[2])
                                        mi_setgroup(2)

                                        mi_addsegment(point2[1], point2[2], point3[1], point3[2])
                                        mi_selectsegment(point2[1] + 0.5, point2[2])
                                        mi_setgroup(2)

                                        mi_addsegment(point3[1], point3[2], point4[1], point4[2])
                                        mi_selectsegment(point4[1], point4[2])
                                        mi_setgroup(2)

                                        mi_addsegment(point5[1], point5[2], point3[1], point3[2])
                                        mi_clearselected()
                                        mi_selectsegment(point5[1], point5[2])
                                        mi_setgroup(2)

                                        mi_selectgroup(2)
                                        mi_mirror(point5[1], point5[2], point6[1], point6[2])



                                        ----------------------------------------------- DEBUG kommentelés --------------------------------------------------

                                        ---- -- Fogfejek közötti levegő
                                        mi_clearselected()
                                        mi_addblocklabel(point1[1], point1[2] + 0.05)
                                        mi_selectlabel(point1[1], point1[2] + 0.05)
                                        mi_setblockprop('Air', 0, 1)
                                        mi_setgroup(2)

                                        ---- -- Hornyok
                                        mi_clearselected()
                                        mi_addblocklabel(point3[1], point3[2] + 0.05)
                                        mi_selectlabel(point3[1], point3[2] + 0.05)
                                        mi_setblockprop('Air', 0, 1)
                                        mi_setgroup(2)

                                        ---- -- Légrés levegő
                                        mi_clearselected()
                                        mi_addblocklabel(r_furat - 0.01, 0.01)
                                        mi_selectlabel(r_furat - 0.01, 0.01)
                                        mi_setblockprop('Air', 0, 0.5)

                                        ---- -- Állórész vastest
                                        mi_clearselected()
                                        mi_addblocklabel(r_belso - 0.01, 0.01)
                                        mi_selectlabel(r_belso - 0.01, 0.01)
                                        mi_setblockprop('Pure Iron', 0, 1)
                                        mi_setgroup(10)  -- - Állórész vastest groupja a 10 ------ EZ VALAMIÉRT NEM MŰKÖDIK!! (?)




                                        if (LNKO == 1) -- ilyenkor fel kell rajzolni a teljes modellt, nincs pizzaszeletelés!
                                        then
                                            mi_selectgroup(2)
                                            mi_copyrotate(0, 0, szelet_deg * 2, Z_modell - 1, 4)

                                            ---- -- Körívek felrajzolása
                                            FEMM_circle_draw(r_kulso, 1)
                                            FEMM_circle_draw(r_belso, 2)
                                            FEMM_circle_draw(r_furat, 2)

                                            ---- -- Körívek felesleges részeinek törlése
                                            for i=0, Z_modell-1, 1 do
                                                mi_selectarcsegment(r_belso * cos(i * szelet_rad * 2), r_belso * sin(i * szelet_rad * 2))
                                                mi_deleteselectedarcsegments()
                                            end

                                            mi_selectnode(r_belso, 0)



                                            if not (Z_modell - floor(Z_modell/2)*2)  ---- -- Ha páratlan a horonyszám, akkor az első foggal szemközt épp horony van: nem kell törölni. /// Lua % : a % b == a - math.floor(a/b)*b
                                            then
                                                mi_selectnode(-r_belso, 0)
                                            end

                                            mi_deleteselectednodes()

                                            ---- -- Határfeltételek megadása
                                            mi_clearselected()
                                            mi_selectarcsegment(0, r_kulso)
                                            mi_setarcsegmentprop(1, 'zeroo', 0, 1)

                                            mi_clearselected()
                                            mi_selectarcsegment(0, -r_kulso)
                                            mi_setarcsegmentprop(1, 'zeroo', 0, 1)

                                            mi_clearselected()
                                            mi_selectcircle(0, 0, r_belso + 1, 4)  ---- -- A maradék motyó, ami nem került bele a sztátor group 2-jébe, most belepottyan.
                                            mi_setgroup(2)

                                            ------ --- End of Sztátor --- ------

                                            ------ --- Rotor --- ------
                                            ---- -- Rotor group: 3
                                            polusszam = p * 2  -- - Változók összehangolása
                                            m_iv_vill_deg = beta  -- - Változók összehangolása
                                            m_iv_mech_deg = m_iv_vill_deg / polusszam  -- (360/2 / polusszam) * (m_iv_vill_deg / 180)
                                            m_iv_vill_rad = rad(m_iv_vill_deg)
                                            m_iv_mech_rad = rad(m_iv_mech_deg)

                                            r_rotor_kulso = r_furat - legres_modell  -- -- a légrés delta (1) mm!
                                            r_rotor_belso = r_rotor_kulso - m_mag_modell

                                            r_rotor_koszoru = r_rotor_belso - b_rot_kosz_modell

                                            r_point1 = {r_rotor_kulso * cos(m_iv_mech_rad), r_rotor_kulso * sin(m_iv_mech_rad)}
                                            r_point2 = {r_rotor_kulso * cos(m_iv_mech_rad), -r_rotor_kulso * sin(m_iv_mech_rad)}

                                            r_point3 = {r_rotor_belso * cos(asin((r_rotor_kulso * sin(m_iv_mech_rad)) / r_rotor_belso)),
                                                        r_rotor_kulso * sin(m_iv_mech_rad)}
                                            r_point4 = {r_rotor_belso * cos(asin((r_rotor_kulso * sin(m_iv_mech_rad)) / r_rotor_belso)),
                                                        - r_rotor_kulso * sin(m_iv_mech_rad)}

                                            temp1 = deg(atan(r_point3[2] / r_point3[1]))  ---- -- Mágnes sarka által bezárt szög.
                                            temp3 = 360 / polusszam / 2  ---- -- Maximálisan bezárható szög.
                                            ---- -- Valamiért az if() nem eszi meg ezeket simán, ezért tettem külön változtóba őket.


                                            if (temp1 < temp3)  ---- -- Maximális mágnesív vizsgálata
                                            then

                                                mi_clearselected()
                                                mi_addnode(r_point1[1], r_point1[2])
                                                mi_selectnode(r_point1[1], r_point1[2])
                                                mi_setgroup(3)

                                                mi_addnode(r_point2[1], r_point2[2])
                                                mi_selectnode(r_point2[1], r_point2[2])
                                                mi_setgroup(3)

                                                mi_addnode(r_point3[1], r_point3[2])
                                                mi_selectnode(r_point3[1], r_point3[2])
                                                mi_setgroup(3)

                                                mi_addnode(r_point4[1], r_point4[2])
                                                mi_selectnode(r_point4[1], r_point4[2])
                                                mi_setgroup(3)

                                                mi_addsegment(r_point1[1], r_point1[2], r_point3[1], r_point3[2])
                                                mi_selectsegment(r_point1[1], r_point1[2])
                                                mi_setgroup(3)

                                                mi_addsegment(r_point2[1], r_point2[2], r_point4[1], r_point4[2])
                                                mi_selectsegment(r_point2[1], r_point2[2])
                                                mi_setgroup(3)

                                                ---- -- Mágnesek közötti levegő definiálása
                                                mi_clearselected()
                                                mi_addblocklabel(r_point3[1], r_point3[2] + 0.01)
                                                mi_selectlabel(r_point3[1], r_point3[2] + 0.01)
                                                mi_setblockprop('Air', 0, 2)
                                                mi_setgroup(3)

                                                mi_selectcircle(0, 0, r_furat - legres_modell / 2, 4)
                                                mi_copyrotate(0, 0, (360 / polusszam), polusszam - 1, 4)  ---- -- Szeletekből egész pizza.

                                                FEMM_circle_draw(r_rotor_kulso, 3)  ---- -- Rotor külső körív
                                                FEMM_circle_draw(r_rotor_belso, 3)  ---- -- Rotor belső körív
                                                FEMM_circle_draw(r_rotor_koszoru, 3)  ---- -- Rotor koszorú körív

                                                ---- -- Mágnesek anyagának definiálása
                                                mi_clearselected()

                                                for i=0, (floor(polusszam / 2) -1), 1 do
                                                    mi_addblocklabel(r_rotor_kulso - 0.1, 0)
                                                    mi_selectlabel(r_rotor_kulso - 0.1, 0)
                                                    mi_setblockprop("N38", 0, 1, 0, 180, 0, 0)
                                                    mi_setgroup(200)  -- - Mágnesek groupja a 200
                                                    mi_selectlabel(r_rotor_kulso - 0.1, 0)
                                                    mi_moverotate(0, 0, -360 / polusszam + (i + 1) * 2 * 360 / polusszam)
                                                    mi_clearselected()
                                                end

                                                for i=0, (floor(polusszam / 2) -1), 1 do
                                                    mi_addblocklabel(r_rotor_kulso - 0.1, 0)
                                                    mi_selectlabel(r_rotor_kulso - 0.1, 0)
                                                    mi_setblockprop("N38", 0, 1, 0, 0, 0, 0)
                                                    mi_setgroup(200)  -- - Mágnesek groupja a 200
                                                    mi_selectlabel(r_rotor_kulso - 0.1, 0)
                                                    mi_moverotate(0, 0, (i + 1) * 2 * 360 / polusszam)
                                                    mi_clearselected()
                                                end
                                                ---- -- Rotor koszorú anyagának definiálása

                                                mi_clearselected()
                                                mi_addblocklabel(r_rotor_belso - 0.1, 0.01)  -- -20
                                                mi_selectlabel(r_rotor_belso - 0.1, 0.01)
                                                mi_setblockprop('Pure Iron', 0, 4)
                                                mi_setgroup(199)  -- - Rotorkoszorú vas groupja a 199

                                                mi_clearselected()
                                                mi_addblocklabel(-0.1, 0.01)
                                                mi_selectlabel(-0.1, 0.01)
                                                mi_setblockprop("Air", 0, 4)

                                            end -- mágnesív if


                                        else  -- pizzaszeletelés

                                            mi_addnode(0, 0)  -- - Tengely pont

                                            mi_selectgroup(2)
                                            mi_copyrotate(0, 0, szelet_deg * 2, Z_modell_per - 1, 4)

                                            ---- -- Körívek felrajzolása
                                            FEMM_arc_draw(r_kulso, 360 / LNKO, 1)
                                            FEMM_arc_draw_2(r_belso, 360 / LNKO, 2)
                                            FEMM_arc_draw(r_furat, 360 / LNKO, 2)

                                            ---- -- Körívek felesleges részeinek törlése
                                            for i=1, Z_modell_per-1, 1 do
                                                mi_selectarcsegment(r_belso * cos(i * szelet_rad*2), r_belso * sin(i * szelet_rad*2))
                                                mi_deleteselectedarcsegments()
                                            end

                                            mi_selectnode(r_belso, 0)


                                            -- mi_clearselected()
                                            -- mi_selectnode(r_belso * cos(radians(360 / LNKO)), r_belso * sin(radians(360 / LNKO)))
                                            -- mi_deleteselected()

                                            mi_clearselected()
                                            mi_selectcircle(0, 0, r_belso + 1, 4)  ---- -- A maradék motyó, ami nem került bele a sztátor group 2-jébe, most belepottyan.
                                            mi_setgroup(2)

                                            ---- -- Határfeltétel megadása a szélére
                                            mi_clearselected()
                                            mi_selectarcsegment(0, r_kulso)
                                            mi_setarcsegmentprop(1, 'zeroo', 0, 1)

                                            ------ --- End of Sztátor --- ------

                                            ------ --- Rotor --- ------
                                            ---- -- Rotor group: 3
                                            polusszam = p * 2  -- - Változók összehangolása
                                            m_iv_vill_deg = beta  -- - Változók összehangolása
                                            m_iv_mech_deg = m_iv_vill_deg / polusszam  -- (360/2 / polusszam) * (m_iv_vill_deg / 180)
                                            m_iv_vill_rad = rad(m_iv_vill_deg)
                                            m_iv_mech_rad = rad(m_iv_mech_deg)

                                            r_rotor_kulso = r_furat - legres_modell  ---- -- a légrés delta (1) mm!
                                            r_rotor_belso = r_rotor_kulso - m_mag_modell

                                            r_rotor_koszoru = r_rotor_belso - b_rot_kosz_modell

                                            r_point1 = {r_rotor_kulso * cos(m_iv_mech_rad), r_rotor_kulso * sin(m_iv_mech_rad)}
                                            -- r_point2 = [r_rotor_kulso * cos(m_iv_mech_rad), -r_rotor_kulso * sin(m_iv_mech_rad)]

                                            r_point3 = {r_rotor_belso * cos(asin((r_rotor_kulso * sin(m_iv_mech_rad)) / r_rotor_belso)),
                                                        r_rotor_kulso * sin(m_iv_mech_rad)}
                                            -- r_point4 = [r_rotor_belso * cos(asin((r_rotor_kulso * sin(m_iv_mech_rad)) / r_rotor_belso)), - r_rotor_kulso * sin(m_iv_mech_rad)]

                                            temp1 = deg(atan(r_point3[2] / r_point3[1]))  ---- -- Mágnes sarka által bezárt szög.
                                            temp3 = 360 / polusszam / 2  ---- -- Maximálisan bezárható szög.
                                            ---- -- Valamiért az if() nem eszi meg ezeket simán, ezért tettem külön változtóba őket.



                                            if (temp1 < temp3)  ---- -- Maximális mágnesív vizsgálata
                                            then

                                                mi_clearselected()
                                                mi_addnode(r_point1[1], r_point1[2])
                                                mi_selectnode(r_point1[1], r_point1[2])
                                                mi_setgroup(3)

                                                -- mi_addnode(r_point2[1], r_point2[2])
                                                -- mi_selectnode(r_point2[1], r_point2[2])
                                                -- mi_setgroup(3)

                                                mi_addnode(r_point3[1], r_point3[2])
                                                mi_selectnode(r_point3[1], r_point3[2])
                                                mi_setgroup(3)

                                                -- mi_addnode(r_point4[1], r_point4[2])
                                                -- mi_selectnode(r_point4[1], r_point4[2])
                                                -- mi_setgroup(3)

                                                mi_addsegment(r_point1[1], r_point1[2], r_point3[1], r_point3[2])
                                                mi_selectsegment(r_point1[1], r_point1[2])
                                                mi_setgroup(3)

                                                -- mi_addsegment(r_point2[1], r_point2[2], r_point4[1], r_point4[2])
                                                -- mi_selectsegment(r_point2[1], r_point2[2])
                                                -- mi_setgroup(3)

                                                mi_selectgroup(3)
                                                mi_mirror(0, 0, cos(2 * pi / polusszam / 2), sin(2 * pi / polusszam / 2))

                                                ---- -- Mágnesek közötti levegő definiálása
                                                mi_clearselected()
                                                mi_addblocklabel(r_point3[1], r_point3[2] + 0.01)
                                                mi_selectlabel(r_point3[1], r_point3[2] + 0.01)
                                                mi_setblockprop('Air', 0, 2)
                                                mi_setgroup(3)

                                                mi_selectcircle(0, 0, r_furat - legres_modell / 2, 4)
                                                mi_copyrotate(0, 0, (360 / polusszam), 2 * p_modell_per - 1, 4)  ---- -- Szeletekből egész pizza.

                                                ---- -- Körívek felrajzolása
                                                FEMM_arc_draw(r_rotor_kulso, 360 / LNKO, 3)  ---- -- Rotor külső körív
                                                FEMM_arc_draw(r_rotor_belso, 360 / LNKO, 3)  ---- -- Rotor belső körív
                                                FEMM_arc_draw(r_rotor_koszoru, 360 / LNKO, 3)  ---- -- Rotor koszorú körív

                                                ---- -- Mágnesek anyagának definiálása
                                                mi_clearselected()

                                                for i=0, (floor(polusszam / LNKO / 2) -1), 1 do
                                                    mi_addblocklabel(r_rotor_kulso - 0.1, 0)
                                                    mi_selectlabel(r_rotor_kulso - 0.1, 0)
                                                    mi_setblockprop("N38", 0, 1, 0, 180, 0, 0)
                                                    mi_setgroup(200)  -- - Mágnesek groupja a 200
                                                    mi_selectlabel(r_rotor_kulso - 0.1, 0)
                                                    mi_moverotate(0, 0, -360 / polusszam + (i + 1) * 2 * 360 / polusszam)
                                                    mi_clearselected()
                                                end

                                                for i=0, (floor(polusszam / LNKO / 2) -2), 1 do  -- a "-2"-t még felül kell vizsgálni todo
                                                    mi_addblocklabel(r_rotor_kulso - 0.1, 0)
                                                    mi_selectlabel(r_rotor_kulso - 0.1, 0)
                                                    mi_setblockprop("N38", 0, 1, 0, 0, 0, 0)
                                                    mi_setgroup(200)  -- - Mágnesek groupja a 200
                                                    mi_selectlabel(r_rotor_kulso - 0.1, 0)
                                                    mi_moverotate(0, 0, (i + 1) * 2 * 360 / polusszam)
                                                    mi_clearselected()
                                                end

                                                mi_addblocklabel(r_rotor_kulso - 0.1, -0.001)
                                                mi_selectlabel(r_rotor_kulso - 0.1, -0.001)
                                                mi_setblockprop("N38", 0, 1, 0, 0, 0, 0)
                                                mi_setgroup(200)  -- - Mágnesek groupja a 200
                                                mi_selectlabel(r_rotor_kulso - 0.1, -0.001)
                                                mi_moverotate(0, 0, (polusszam / LNKO / 2) * 2 * 360 / polusszam)
                                                mi_clearselected()

                                                mi_addblocklabel(r_rotor_kulso - 0.1, 0.001)
                                                mi_selectlabel(r_rotor_kulso - 0.1, 0.001)
                                                mi_setblockprop("N38", 0, 1, 0, 0, 0, 0)
                                                mi_setgroup(200)  -- - Mágnesek groupja a 200

                                                ---- -- Rotor koszorú anyagának definiálása

                                                mi_clearselected()
                                                mi_addblocklabel(r_rotor_belso - 0.1, 0.01)  -- -20
                                                mi_selectlabel(r_rotor_belso - 0.1, 0.01)
                                                mi_setblockprop('Pure Iron', 0, 2)
                                                mi_setgroup(199)  -- - Rotorkoszorú vas groupja a 199

                                                mi_clearselected()
                                                mi_addblocklabel(0.1, 0.01)
                                                mi_selectlabel(0.1, 0.01)
                                                mi_setblockprop("Air", 0, 4)

                                                mi_addsegment(0, 0, r_kulso, 0)
                                                mi_addsegment(0, 0, r_kulso * cos(rad(360 / LNKO)),
                                                                   r_kulso * sin(rad(360 / LNKO)))

                                                mi_clearselected()
                                                mi_selectsegment(r_kulso - 0.001, 0)
                                                mi_selectsegment((r_kulso - 0.001) * cos(rad(360 / LNKO)),
                                                                      (r_kulso - 0.001) * sin(rad(360 / LNKO)))
                                                mi_setsegmentprop("per1", 0, 1, 0, 666)

                                                mi_clearselected()
                                                mi_selectsegment(r_furat - 0.001, 0)
                                                mi_selectsegment((r_furat - 0.001) * cos(rad(360 / LNKO)),
                                                                      (r_furat - 0.001) * sin(rad(360 / LNKO)))
                                                mi_setsegmentprop("per2", 0, 1, 0, 666)

                                                mi_clearselected()
                                                mi_selectsegment(r_rotor_kulso - 0.001, 0)
                                                mi_selectsegment((r_rotor_kulso - 0.001) * cos(rad(360 / LNKO)),
                                                                      (r_rotor_kulso - 0.001) * sin(rad(360 / LNKO)))
                                                mi_setsegmentprop("per3", 0, 1, 0, 666)

                                                mi_clearselected()
                                                mi_selectsegment(r_rotor_belso - 0.001, 0)
                                                mi_selectsegment((r_rotor_belso - 0.001) * cos(rad(360 / LNKO)),
                                                                      (r_rotor_belso - 0.001) * sin(rad(360 / LNKO)))
                                                mi_setsegmentprop("per4", 0, 1, 0, 666)

                                                mi_clearselected()
                                                mi_selectsegment(0.001, 0)
                                                mi_selectsegment((0.001) * cos(rad(360 / LNKO)),
                                                                      (0.001) * sin(rad(360 / LNKO)))
                                                mi_setsegmentprop("per5", 0, 1, 0, 666)

                                            end -- mágnesív if


                                        end -- if (teljes karika vagy pizzaszelet)

                                        mi_zoomnatural()



                                        if (temp1 < temp3)  ---- -- Maximális mágnesív vizsgálata
                                        then

                                        mi_analyze()
                                        mi_loadsolution()

                                        mo_addcontour((point3[1] + point4[1]) / 2, point3[2])
                                        mo_addcontour((point3[1] + point4[1]) / 2, 0)
                                        Bn_f, Bn_avg = mo_lineintegral(0)  -- Bn fogközépnél


                                        mo_clearcontour()
                                        mo_addcontour(r_point3[1], r_point3[2])
                                        mo_addcontour(r_rotor_belso, 0)
                                        -- mo_bendcontour(beta/180 / p / 2, 1)
                                        Bn_t, Bn_avg = mo_lineintegral(0)  -- Bn total

                                        -- print(Z, p, beta, b_fogperm_szel, b_fogPERtau_p, l_fogPERD, b_stat_koszPERD, b_rot_koszPERD, b_fogPERtau_h, m_magPERD, m_magPERtau_p)
                                        -- print(Bn_f, Bn_t)
                                        szoras = (Bn_t - Bn_f) / Bn_t

                                        print(szoras)
                                        -- time.sleep(5)

                                        -- -- - Új sor hozzáadása az adattömbhöz
                                        -- new_row = pd.DataFrame(
                                        --     {'Z': [Z], 'foghossz': [foghossz], 'm_kit': [m_kit], 'm_mag': [m_mag], 'stat_kosz': [stat_kosz],
                                        --      'rot_kosz': [rot_kosz], 'legres': [legres], 'szoras': [szoras]})  -- TODO
                                        -- new_row.to_csv('train_data.csv', mode='a', header=False, index=False)
                                        -- -- -

                                        -- print("szórás: ", szoras)

                                        ----------------------------------------------- DEBUG kommentelés --------------------------------------------------


                                        path_txt = filename .. ".txt"
                                        handle=openfile(path_txt,"a")
                                        write(handle, Z_modell, "\t", p_modell, "\t", beta, "\t", b_fogperm_szel, "\t", b_fogpertau_p, "\t", l_fogperd, "\t", b_stat_koszperd, "\t", b_rot_koszperd, "\t", b_fogpertau_h, "\t", m_magperd, "\t", m_magpertau_p, "\t", szoras, "\t", "\n")
                                        closefile(handle)



                                        print(Z_modell, p_modell, beta, b_fogperm_szel, b_fogpertau_p, l_fogperd, b_stat_koszperd, b_rot_koszperd, b_fogpertau_h, m_magperd, m_magpertau_p)
                                        print(Z_modell, p_modell, b_fog_modell, l_fog_modell, b_stat_kosz_modell, b_rot_kosz_modell, beta, m_mag_modell)




                                        mi_saveas(filename)
                                        --print("script ended")
                                        --return szoras

                                        end -- magnesiv if 2

                                    mi_close()
                                    --mo_close()
--                                     end
--                                 end
                            end
                        end
                    end
                end
            end
        end
    end
end



print(filename)
print(Z_modell, p_modell, beta, b_fogperm_szel, b_fogpertau_p, l_fogperd, b_stat_koszperd, b_rot_koszperd, b_fogpertau_h, m_magperd, m_magpertau_p)
print("vege")

messagebox("finito")

--
