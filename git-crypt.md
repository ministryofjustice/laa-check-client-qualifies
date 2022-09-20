#Add a new user for git-crypt

* have the user publish their public key

        gpg [--keyserver pgp.mit.edu] --send-keys A1234BBB1232CCCETC
* start a new git branch `git checkout -b add-<name>-as-gpg-user`
* obtain the user key ID from a keystore (for example pgp.key-server.io)

        gpg [--keyserver pgp.mit.edu] --recv-key A1234BBB1232CCCETC
* add trust, there are 5 available levels:

  1 = I don't know or won't say

  2 = I do NOT trust

  3 = I trust marginally

  4 = I trust fully

  5 = I trust ultimately


        gpg --edit-key <email>

  - at the gpg prompt
        
    - first type: `trust`
    - then select: `5`

            *Note*: Using permissions lower than 5 may cause issues with git-crypt
  - confirm
  - type `quit` to exit the gpg prompt
* add user to git-crypt:

        git-crypt add-gpg-user <email>

  This will create a commit with the appropriate changes

* Push your branch to github
* merge
