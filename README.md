# depth-strider
Venture through and discover space! but make sure your spaceship is healthy...

# Links
- [Designdokument](https://docs.google.com/document/d/1A-8uSrF0IEHpkhcQhKX560UWbpnNuRDRH8o64AUP_Ak/edit?usp=sharing)
- [Changelog](https://docs.google.com/document/d/1lqR5nUgXg9rzvYWw112uOyoJ1pwzOjbHMqLbChRb9HI/edit?usp=sharing)
- [Fokustest 1](https://docs.google.com/document/d/1GCDP0RlplobkzyGyrilFvHJdaTbkVn7kZlDdzsdHkc4/edit?usp=sharing)
- [Fokustest 2](https://docs.google.com/document/d/1F7RhVATzezgzKcFsvvhxtUv4rkbkNxSTL4eO07AjAu8/edit?usp=sharing)
## Git Workflow

Für ein neues Feature soll ein neuer Branch angelegt werden.

```
git checkout -b <feature_branch_name>
```

Nach dem Arbeiten auf dem Branch Änderungen committen.

```
git commit -m "<commit_message>"
```

Damit der Branch nicht nur auf dem lokalen Repository verfügbar ist, muss dieser aufs Remote-Repository gepusht werden:

```
git push -u origin <feature_branch_name>
```

Um sich auf den finalen Pull-Request vorzubereiten müssen alle Updates des **remote dev-Branches** auf den **lokalen Feature-Branch** gepullt werden.

```
git pull origin dev
```

Nun kann eine **Pull-Request**, um den Feature-Branch auf den dev-Branch zu ziehen, erstellt werden. Andere Teammitglieder schauen sich diese Pull-Request (**Review**) an und geben dazu Feedback. Ist das **Einverständnis** des Teams da, kann die Pull-Request durchgeführt werden.

Nun sollte der lokale dev-Branch geupdatet werden. Man wechsle auf den Main Branch und pullt.

```
git checkout dev
git pull
```

Schlussendlich sollte der Feature-Branch **lokal** sowie **remote** gelöscht werden, falls dieser nicht mehr benötigt wird.

```
git branch -D <feature_branch_name>
```
