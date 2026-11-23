(lang dune 3.24)

(name commodity_trader)

(generate_opam_files true)

(source
 (github jhkim2275/commodity-trader))

(authors
 "Junghoon Kim"
 "Connie Lu"
 "Danny Lin"
 "Wyatt Cox"
 "Shreya Anand")

(maintainers
 "Junghoon Kim"
 "Connie Lu"
 "Danny Lin"
 "Wyatt Cox"
 "Shreya Anand")

(package
 (name commodity_trader)
 (synopsis "A terminal commodity trading game driven by news headlines")
 (description
  "Trade wheat, oil, gold, lumber, and cattle against bots as news headlines move prices. Reach as many headlines as possible before the clock runs out. CS 3110 final project.")
 (depends
  (ocaml
   (>= 5.0))
  (lwt
   (>= 5.0))
  (ounit2 :with-test)
  (bisect_ppx :with-test))
 (tags
  (game trading cs3110)))
