linenumber=$(sed -n '$=' dependency_present.txt)
for (( x=1; x<=$linenumber; x++ ))
do
linew=$(sed -n "${x}p" dependency_present.txt)
if [[ $linew == "requirements.txt" ]]
then
echo "PYTHON"
chmod +x ./python_req.sh
./python_req.sh
fi
if [[ $linew == "packages.json" ]]
then
echo "Node"
chmod +x ./node.sh
./node.sh
fi
if [[ $linew == "build.gradle" ]]
then
echo "Gradle"
chmod +x ./gradle.sh
./gradle.sh
fi
if [[ $linew == "pom.xml" ]]
then
echo "Maven"
chmod +x ./maven.sh
./maven.sh
fi
if [[ $linew == "gemfile" ]]
then
echo "Ruby"
chmod +x ./ruby_gemfile.sh
./ruby_gemfile.sh
fi
if [[ $linew == "cargo.toml" ]]
then
echo "Cargo"
chmod +x ./cargo.sh
./cargo.sh
fi
if [[ $linew == "package.yaml" ]]
then
echo "Haskell"
chmod +x ./haskell.sh
./haskell.sh
fi
if [[ $linew == "composer.json" ]]
then
echo "PHP"
chmod +x ./php.sh
./php.sh
fi
if [[ $linew == "package.swift" ]]
then
echo "Swift"
chmod +x ./swift.sh
./swift.sh
fi
if [[ $linew == "packages.config" ]]
then
echo "C#"
chmod +x ./csharp.sh
./csharp.sh
fi
done
rm dependency_present.txt
