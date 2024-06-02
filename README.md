# depth-strider
Venture through and discover space! but make sure your spaceship is healthy...

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
