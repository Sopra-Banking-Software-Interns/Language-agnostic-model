linenumber=$(sed -n '$=' dependency_present.txt)
for (( x=1; x<=$linenumber; x++ ))
do
linew=$(sed -n "${x}p" dependency_present.txt)
echo "$linew"
echo "${x}"
case $linew in
  "requirements.txt")
    echo "PYTHON"
    chmod +x ./python_req.sh
    ./python_req.sh
    ;;
  "packages.json")
    echo "Node"
    chmod +x ./node.sh
    ./node.sh
    ;;
  "build.gradle")
    echo "Gradle"
    chmod +x ./gradle.sh
    ./gradle.sh
    ;;
  "pom.xml")
    echo "Maven"
    chmod +x ./maven.sh
    ./maven.sh
    ;;
  "gemfile")
    echo "Ruby"
    chmod +x ./ruby_gemfile.sh
    ./ruby_gemfile.sh
    ;;
  "cargo.toml")
    echo "Cargo"
    chmod +x ./cargo.sh
    ./cargo.sh
    ;;
  "package.yaml")
    echo "Haskell"
    chmod +x ./haskell.sh
    ./haskell.sh
    ;;
  "composer.json")
    echo "PHP"
    chmod +x ./php.sh
    ./php.sh
    ;;
  "package.swift")
    echo "Swift"
    chmod +x ./swift.sh
    ./swift.sh
    ;;
  "packages.config")
    echo "C#"
    chmod +x ./csharp.sh
    ./csharp.sh
    ;;
esac
done
rm dependency_present.txt
