# ABL-distance-between-two-points-lat-lon
Calculate distance in meters between two between two points (lat_1, lon_1, lat_2, lon_2)

```
DEF VAR distance_in_meters AS DECIMAL NO-UNDO.

RUN prCalculateDistance(-16.8287433,-49.2197831,
                        -16.6768863,-49.241411, 
                        OUTPUT distance_in_meters).
                        
MESSAGE distance_in_meters VIEW-AS ALERT-BOX.
```
