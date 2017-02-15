# Airfoil-utils

Assortment of tools to fetch airfoils, adjust them, and generate
g-code to cut them. Profiles are nabbed from http://m-selig.ae.illinois.edu/ads/coord/

![Blade Example](http://crepinc.com/assets/projects/2017-02-04_jetblades/blade_gcode.png)

```
CL-USER> (ql:quickload 'airfoil-utils)
[...]
(AIRFOIL-UTILS)
CL-USER> (airfoil-utils:fetch-available-airfoils)
("2032c" "a18" "a18sm" "a63a108c" "ag03" "ag04" "ag08" "ag09" "ag10" "ag11"
 "ag12" "ag13" "ag14" "ag16" "ag17" "ag18" "ag19" "ag24" "ag25" "ag26" "ag27"
[...]
 "naca000834" "naca0010" "naca001034" "naca001035" "naca001064" "naca001065"
 "naca001066" "naca001234" "naca001264" "naca0015" "naca0018" "naca0021"
[...]
 "usa45m" "usa46" "usa48" "usa49" "usa5" "usa50" "usa51" "usa98" "usnps4"
 "v13006" "v13009" "v23010" "v43012" "v43015" "vr1" "vr11x" "vr12" "vr13"
 "vr14" "vr15" "vr5" "vr7" "vr7b" "vr8" "vr8b" "vr9" "waspsm" "wb13535sm"
 "wb140" "whitcomb" "ys900" "ys915" "ys930")
CL-USER> (airfoil-utils:print-2d-gcode "naca2408")
g1 x1.00000 y0.00084
g1 x0.95033 y0.00855
g1 x0.90054 y0.01575
g1 x0.80078 y0.02858
g1 x0.70081 y0.03942
g1 x0.60068 y0.04820
g1 x0.50039 y0.05473
g1 x0.40000 y0.05869
g1 x0.29900 y0.05875
g1 x0.24852 y0.05677
g1 x0.19809 y0.05320
g1 x0.14778 y0.04776
g1 x0.09768 y0.03987
g1 x0.07273 y0.03471
g1 x0.04794 y0.02829
g1 x0.02337 y0.01944
g1 x0.01128 y0.01380
g1 x0.00000 y0.00000
g1 x0.01372 y-0.01134
g1 x0.02663 y-0.01493
g1 x0.05206 y-0.01891
g1 x0.07727 y-0.02111
g1 x0.10232 y-0.02237
g1 x0.15222 y-0.02338
g1 x0.20191 y-0.02320
g1 x0.25148 y-0.02239
g1 x0.30100 y-0.02125
g1 x0.40000 y-0.01869
g1 x0.49961 y-0.01585
g1 x0.59932 y-0.01264
g1 x0.69919 y-0.00942
g1 x0.79922 y-0.00636
g1 x0.89946 y-0.00353
g1 x0.94967 y-0.00217
g1 x1.00000 y-0.00084
NIL
CL-USER>
CL-USER> (in-package airfoil-utils)
#<PACKAGE "AIRFOIL-UTILS">
AIRFOIL-UTILS> (setf *plot-pts*
                (translate-2d 0.0 1.0
                 (scale-2d 2.0
                  (rotate-2d 15.0
                   (fetch-airfoil-pts "naca2408")))))
((1.9314168459006713d0 1.519260848124104d0)
 (1.8314707815277405d0 1.5084443389599056d0)
 [...]
 (1.835744797419249d0 1.4873932376452714d0)
 (1.9322864779092477d0 1.5160153372842085d0))
AIRFOIL-UTILS> (start-http)
Toot server is started.
Listening on localhost:8803.
T
AIRFOIL-UTILS>
```

```
~/Projects/airfoil-utils $ curl localhost:8803/airfoil-pts/current
{"plot_set":"current","plot_pts":[[1.9314168459006713,1.519260848124104],[1.8314707815277405,1.5084443389599056],[1.7315569281701564,1.4965804808558545],[1.5321940808577859,1.4697265530919055],[1.33345572147783,1.438919563275631],[1.1354744321222405,1.4040500861591814],[0.9383488396423254,1.3647511374398629],[0.742360538792455,1.320435631643642],[0.5472124048319807,1.2682700705176146],[0.45071742300283557,1.2383146307989505],[0.3551421646168333,1.2053134402614132],[0.2607666580658044,1.168761790014615],[0.1680650364222238,1.1275858189045906],[0.1225363421925291,1.1047023866989398],[0.07796899135169968,1.0794676536517895],[0.03508448821687214,1.0496524012872723],[0.014647882028053264,1.0324985120735126],[0.0,1.0],[0.03237502195199975,0.9851947975326213],[0.05917354608678722,0.9849421568270268],[0.11036073438516236,0.9904169225671233],[0.16020152606820307,0.9992165034413889],[0.20924661580628282,1.0097492065493836],[0.30616882629317693,1.0336281721414156],[0.4020694031826868,1.0596973556240632],[0.49741196875927995,1.0869214650286454],[0.5924871535321653,1.1147572170423212],[0.7824153632718145,1.170948942515972],[0.9733769760331985,1.2279973197169698],[1.1643402646143088,1.285812249458186],[1.3556074809258272,1.3437293274134425],[1.5472667572040728,1.401420164015537],[1.7394505595332495,1.4587753226685118],[1.835744797419249,1.4873932376452714],[1.9322864779092477,1.5160153372842085]]}
~/Projects/airfoil-utils $ 
```

This project breaks my single-file ugly code into something sustainable, still
a WIP. Todos:
- fix the web viewer to match the new http stuff
- make more helpers for single-func generation of code to cut blades or blisks
- move flow solver stuff into here for all-in-one-place usage
- allow constraint based hands-off parametric optimization (nothing too fancy)
- make more of the functionality available via the web front end?
