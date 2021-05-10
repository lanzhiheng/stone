import hljs from 'highlight.js/lib/index'

document.addEventListener('turbo:load', (event) => {
  document.querySelectorAll('pre code').forEach((block) => {
    hljs.highlightBlock(block);
  });
});
