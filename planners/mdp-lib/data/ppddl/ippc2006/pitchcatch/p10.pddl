(define (domain pitchcatch)
(:requirements :adl :probabilistic-effects)
(:types balltype bit difficulty)
(:constants  T0 T1 T2 T3 - balltype Easy Medium Hard - difficulty B0 B1 B2 B3 B4 B5 - bit)
(:predicates
  (alive)
  (ball-in-the-air-of-type ?t - balltype)
  (catchable ?t - balltype ?B0 ?B1 ?B2 - bit)
  (bit-on ?b - bit)
  (bit-off ?b - bit)
  (thrown)
  (not-thrown)
  (caught ?t - balltype)
  (deposited ?t - balltype)
  (similar ?t1 ?t2 - balltype)
  (difficulty-setting ?b - bit ?d - difficulty)
)

(:action catch
 :parameters (?T ?Tball - balltype ?B0 ?B1 ?B2 - bit)
 :precondition (and (thrown)
                    (ball-in-the-air-of-type ?Tball)
                    (catchable ?T ?B0 ?B1 ?B2 ))
 :effect (and (not (thrown))
              (not-thrown)
              (not (bit-on ?B0))
              (bit-off ?B0)
              (not (bit-on ?B1))
              (bit-off ?B1)
              (not (bit-on ?B2))
              (bit-off ?B2)
              (probabilistic 4/10
              (when (and 
                          (bit-on ?B0)
                          (bit-on ?B1)
                          (bit-on ?B2)
                          (= ?T ?Tball))
                          (caught ?Tball)))
              (probabilistic 1/10
              (when (and 
                          (bit-on ?B0)
                          (bit-on ?B1)
                          (bit-on ?B2)
                          (similar ?T ?Tball))
                          (caught ?Tball)))))
(:action deposit-ball
 :effect      (and (forall (?t1 - balltype) (not (ball-in-the-air-of-type ?t1)))
                   (forall (?t1 - balltype) (when (caught ?t1) (deposited ?t1)))))
(:action pass
 :precondition (thrown)
 :effect (and (not (thrown))
              (not-thrown)
              (forall (?t - balltype) (not (ball-in-the-air-of-type ?t)))
              (probabilistic 5/100 (not (alive)))))
(:action pitch
 :precondition (and (not-thrown)
                    (alive))
 :effect  (and (thrown)
               (not (not-thrown))
               (probabilistic 34/100 (ball-in-the-air-of-type T0))
               (probabilistic 48/100 (ball-in-the-air-of-type T1))
               (probabilistic 13/100 (ball-in-the-air-of-type T2))
               (probabilistic 43/100 (ball-in-the-air-of-type T3))
               (forall (?B - bit)
                       (probabilistic
                           1/10 (and (bit-on ?B) (not (bit-off ?B)))))))
(:action set-bit
 :parameters (?B - bit)
 :precondition (not-thrown)
 :effect (and (bit-on ?B)
              (not (bit-off ?B))
              (probabilistic 5/100
                    (when (difficulty-setting ?B Easy)
                          (not (alive))))
              (probabilistic 1/10 
                    (when (difficulty-setting ?B Medium)
                          (not (alive))))
              (probabilistic 2/10
                    (when (difficulty-setting ?B Hard)
                          (not (alive))))))
)

(define (problem p10) 
(:domain pitchcatch)  
(:init (alive) 
       (not-thrown)
       (bit-on B0)
       (bit-on B1)
       (bit-on B2)
       (bit-on B3)
       (bit-on B4)
       (bit-on B5)
       (difficulty-setting B0 Easy)
       (difficulty-setting B1 Easy)
       (difficulty-setting B2 Medium)
       (difficulty-setting B3 Medium)
       (difficulty-setting B4 Hard)
       (difficulty-setting B5 Easy)
       (catchable T0 B1 B3 B5 )
       (catchable T1 B3 B2 B4 )
       (catchable T2 B5 B0 B4 )
       (catchable T3 B3 B0 B1 )
)
(:goal (and 
            (deposited T0)
            (deposited T1)
            (deposited T2)
            (deposited T3)
)))
