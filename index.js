#!/usr/bin/env node
import path from 'path';
import os from 'os';
import fse from 'fs-extra';
import chalk from 'chalk';
import { fileURLToPath } from 'url';

// --- Configuration ---
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const SOURCE_SKILLS_DIR = path.join(__dirname, 'skills');

const TARGETS = {
  opencode: {
    path: path.join(os.homedir(), '.config', 'opencode', 'skills'),
    name: 'OpenCode'
  },
  claude: {
    path: path.join(os.homedir(), '.claude', 'skills'),
    name: 'Claude Code'
  }
};

// --- Helper Functions ---
const log = {
  info: (msg) => console.log(chalk.blue(`[INFO] ${msg}`)),
  success: (msg) => console.log(chalk.green(`✅ ${msg}`)),
  error: (msg) => console.error(chalk.red(`❌ [ERROR] ${msg}`)),
  warn: (msg) => console.warn(chalk.yellow(`⚠️ [WARN] ${msg}`))
};

const printUsage = () => {
  log.error('Invalid or missing target environment.');
  console.log('\nUsage:');
  console.log(chalk.cyan('  npx add-rust-skill <target>'));
  console.log('\nAvailable targets:');
  console.log(`  - ${chalk.bold('opencode')}`);
  console.log(`  - ${chalk.bold('claude')}`);
  process.exit(1);
};

// --- Main Execution ---
const main = async () => {
  const targetArg = process.argv[2];

  if (!targetArg || !Object.keys(TARGETS).includes(targetArg)) {
    printUsage();
  }

  const target = TARGETS[targetArg];
  log.info(`Starting rust-skills installation for ${chalk.bold(target.name)}...`);

  try {
    // 1. Ensure source directory exists
    if (!await fse.pathExists(SOURCE_SKILLS_DIR)) {
      log.error(`Source skills directory not found at '${SOURCE_SKILLS_DIR}'`);
      log.error('Please run this command from the root of the "rust-skills" repository.');
      process.exit(1);
    }
    
    // 2. Ensure target directory exists
    await fse.ensureDir(target.path);
    log.info(`Target directory is '${target.path}'`);

    // 3. Copy files
    await fse.copy(SOURCE_SKILLS_DIR, target.path, { overwrite: true });

    log.success(`Successfully installed skills for ${chalk.bold(target.name)}.`);

  } catch (err) {
    log.error('An unexpected error occurred during installation:');
    console.error(err);
    process.exit(1);
  }
};

main();
