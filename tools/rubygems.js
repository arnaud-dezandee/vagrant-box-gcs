const fs = require('fs');
const path = require('path');
const util = require('util');
const SemanticReleaseError = require('@semantic-release/error');
const execa = require('execa');

const exists = util.promisify(fs.access);
const writeFile = util.promisify(fs.writeFile);
const readFile = util.promisify(fs.readFile);

async function checkExist(configName, configFile) {
  try {
    await exists(configFile);
  } catch (err) {
    throw new SemanticReleaseError(`Invalid config ${configName} specified`, 'EINVALIDCONFIG');
  }
}

async function verifyConditions(config, context) {
  const { cwd, env: { GEM_HOST_API_KEY }, logger } = context;

  await checkExist('versionFile', path.resolve(cwd, config.versionFile));
  await checkExist('gemspec', path.resolve(cwd, config.gemspec));

  if (!GEM_HOST_API_KEY) {
    throw new SemanticReleaseError('No RubyGems api key specified', 'ENOGEMHOSTAPIKEY');
  }

  logger.log('Verify RubyGems authentication');
}

async function prepare(config, context) {
  const {
    cwd, env, stdout, stderr, nextRelease: { version }, logger,
  } = context;
  const versionFile = path.resolve(cwd, config.versionFile);
  const gemspec = path.resolve(cwd, config.gemspec);

  logger.log('Write version %s to %s', version, config.versionFile);

  const content = await readFile(versionFile, { encoding: 'utf8' });
  const currentVersion = content.match(/VERSION = ["']([\S ]+)["']/)[1];
  await writeFile(versionFile, content.replace(currentVersion, version));

  logger.log('Building RubyGem %s', config.gemspec);

  const build = execa('gem', ['build', '-V', gemspec], { cwd, env });
  build.stdout.pipe(stdout, { end: false });
  build.stderr.pipe(stderr, { end: false });
  await build;
}

async function publish(config, context) {
  const {
    cwd, env, stdout, stderr, nextRelease: { version }, logger,
  } = context;
  const gempkg = `${path.basename(config.gemspec, '.gemspec')}-${version}.gem`;

  logger.log(`Pushing ${gempkg} to RubyGems.org`);

  const push = execa('gem', ['push', gempkg], { cwd, env });
  push.stdout.pipe(stdout, { end: false });
  push.stderr.pipe(stderr, { end: false });
  await push;
}

module.exports = {
  verifyConditions,
  prepare,
  publish,
};
