import babel from 'rollup-plugin-babel';
import localResolve from 'rollup-plugin-local-resolve';
import nodeResolve from 'rollup-plugin-node-resolve';
import commonjs from 'rollup-plugin-commonjs';
import json from 'rollup-plugin-json';
import { uglify } from 'rollup-plugin-uglify';
import { plugin as analyze } from 'rollup-plugin-analyzer';

export default {
  input: 'es/index.js',
  output: {
    name: 'fontkit',
    format: 'umd',
  },
  // external: ['brotli/decompress'],
  plugins: [
    analyze(),
    // localResolve(),
    nodeResolve({
      browser: true,
    }),
    commonjs(),
    json({
      indent: '',
    }),
    uglify(),
  ],
};
