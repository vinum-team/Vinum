const target = process.argv[2]
const version = process.argv[3]
const { exec, execFileSync } = require('child_process');
const {writeFileSync} = require("fs")
const { join } = require('path');
const deletedir = require('rimraf');

const splitTarget = target.split("/")
const projectName = splitTarget[splitTarget.length - 1]

exec("wally install", {cwd: target}, () => {
  writeFileSync(join(`${target}/intRelease.project.json`), `{
    "name": "${projectName}",
    "tree" : {
      "$path" : "Packages",
      "${projectName}" : {
        "$path" : "lib"
      }
    }
  }`)

  execFileSync('rojo.exe', ["build", `-o ${projectName}-${version}.rbxm`, `${target}/intRelease.project.json`]);

  deletedir(`${target}/Packages`, (err) => {
    if (err) {
        console.log(err)
    } else {
        deletedir(`${target}/intRelease.project.json`, (secArr) => {
          if (err) {
            console.log(secArr)
            return;
          }

          console.log("Built the release in the root directory and cleaned up")
        })
    }
});
})