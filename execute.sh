linenumber=$(sed -n '$=' dependency_present.txt)
while IFS= read -r linew
do
  if [[ $linew == "requirements.txt\n" ]]
  then
    chmod +x ./python_req.sh
    ./python_req.sh
  fi
  if [[ $linew == "packages.json" ]]
  then
    chmod +x ./node.sh
    ./node.sh
  fi
  if [[ $linew == "build.gradle" ]]
  then
    chmod +x ./gradle.sh
    ./gradle.sh
  fi
  if [[ $linew == "pom.xml" ]]
  then
    chmod +x ./maven.sh
    ./maven.sh
  fi
  if [[ $linew == "gemfile" ]]
  then
    chmod +x ./ruby_gemfile.sh
    ./ruby_gemfile.sh
  fi
  if [[ $linew == "cargo.toml" ]]
  then
    chmod +x ./cargo.sh
    ./cargo.sh
  fi
  if [[ $linew == "package.yaml" ]]
  then
    chmod +x ./haskell.sh
    ./haskell.sh
  fi
  if [[ $linew == "composer.json" ]]
  then
    chmod +x ./php.sh
    ./php.sh
  fi
  if [[ $linew == "package.swift" ]]
  then
    chmod +x ./swift.sh
    ./swift.sh
  fi
  if [[ $linew == "packages.config" ]]
  then
    chmod +x ./csharp.sh
    ./csharp.sh
  fi
done < dependency_present.txt

rm dependency_present.txt
