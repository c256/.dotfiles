(fset 'PACG-format-acq
   "[b]Set:[/b] \C-a\C-n[b]Name:[/b] \C-a\C-n[b]Traits:[/b] \C-a\C-n[b]Check to Acquire:[/b] \C-a\C-n[b]Powers:[/b] \C-a\C-[\C-s^.$\C-a")

(fset 'PACG-format-defeat
   "[b]Set:[/b] \C-a\C-n[b]Name:[/b] \C-a\C-n[b]Traits:[/b] \C-a\C-n[b]Check to Defeat:[/b] \C-a\C-n[b]Powers:[/b] \C-a\C-[\C-s^.$\C-a")

(fset 'PACG-format-story-defeat
   "[b]Set:[/b] \C-a\C-n[b]Name:[/b] \C-a\C-n[b]Type:[/b] \C-a\C-n[b]Traits:[/b] \C-a\C-n[b]Check to Defeat:[/b] \C-a\C-n[b]Powers:[/b] \C-a\C-[\C-s^.$\C-a")

(fset 'PACG-format-loot
   "[b]Set:[/b] \C-a\C-n[b]Name:[/b] \C-a\C-n[b]Type:[/b] \C-a\C-n[b]Traits:[/b] \C-a\C-n[b]Powers:[/b] \C-a\C-[\C-s^.$\C-a")

(fset 'PACG-format-loc
   "[b]Set:[/b] \C-a\C-n[b]Name:[/b] \C-a\C-n[b]Monsters:[/b] \C-a\C-n[b]Barriers:[/b] \C-a\C-n[b]Weapons:[/b] \C-a\C-n[b]Spells:[/b] \C-a\C-n[b]Armors:[/b] \C-a\C-n[b]Items:[/b] \C-a\C-n[b]Allies:[/b] \C-a\C-n[b]Blessings:[/b] \C-a\C-n[b]Traits:[/b] \C-a\C-n[b]At This Location:[/b] \C-a\C-n[b]When Closing:[/b] \C-a\C-n[b]When Permanently Closed:[/b] \C-a\C-n[b]At This Location(Back):[/b] \C-a\C-[\C-s^.$\C-a") ;; requires truncate-lines 't

(fset 'PACG-format-scenario
   [?\[ ?b ?\] ?S ?e ?t ?: ?\[ ?/ ?b ?\] ?  ?\C-a ?\C-n ?\[ ?b ?\] ?N ?a ?m ?e ?: ?\[ ?/ ?b ?\] ?  ?\C-a ?\C-n ?\[ ?b ?\] ?\M-f ?\C-f ?\[ ?/ ?b ?\] ?\C-s ?H ?e ?n ?c ?h ?\C-\[ ?b ?\C-? ?\C-m ?\[ ?b ?\] ?\M-f ?\C-f ?\[ ?/ ?b ?\] ?\C-a ?\C-n ?\[ ?b ?\] ?P ?o ?w ?e ?r ?s ?: ?\[ ?/ ?b ?\] ?  ?\C-a ?\C-n ?\[ ?b ?\] ?L ?o ?c ?a ?t ?i ?o ?n ?s ?: ?\[ ?/ ?b ?\] ?  ?\C-a ?\C-n ?\[ ?b ?\] ?R ?e ?w ?a ?r ?d ?s ?: ?\[ ?/ ?b ?\] ?  ?\C-a ?\C-n ?\[ ?b ?\] ?C ?o ?h ?o ?r ?t ?s ?: ?\[ ?/ ?b ?\] ?  ?\C-a ?\C-\[ ?\C-s ?^ ?. ?$ ?\C-a])
