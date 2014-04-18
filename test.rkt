(choice (q "Parlez-vous francais?")
        (a ("Oui."
            ("Non." #t)
            "L'Etat, c'est moi.")))

(section "French Test #1"
         (choice (q "Parlez-vous francais?")
                 (a ("Oui."
                     ("Non." #t)
                     "L'Etat, c'est moi.")))
         (choice (q "Parlez-vous francais?")
                 (a ("Oui."
                     ("Non." #t)
                     "L'Etat, c'est moi."))))


(section "4"
         (section "French Test #1"
                  (choice (q "Parlez-vous francais?")
                          (a ("Oui."
                              ("Non." #t)
                              "L'Etat, c'est moi.")))))

(section "some other"
         (section "4"
                  (section "French Test #1"
                           (choice (q "Parlez-vous francais?")
                                   (a ("Oui."
                                       ("Non." #t)
                                       "L'Etat, c'est moi.")))
                           (choice (q "Parlez-vous francais?")
                                   (a ("Oui."
                                       ("Non." #t)
                                       "L'Etat, c'est moi.")))
                           (choice (q "Parlez-vous francais?")
                                   (a ("Oui."
                                       ("Non." #t)
                                       "L'Etat, c'est moi."))))))