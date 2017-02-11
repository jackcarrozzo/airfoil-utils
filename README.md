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
```
