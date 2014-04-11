CKEDITOR.editorConfig = function(config) {
  config.language = 'es';
  config.toolbarGroups = [
  { name: 'clipboard',   groups: [ 'clipboard', 'undo' ] },
  { name: 'editing',     groups: [ 'find', 'selection', 'spellchecker' ] },
  { name: 'links' },
  { name: 'insert' },
  { name: 'tools' },
  { name: 'document',    groups: [ 'document', 'doctools' ] },
  { name: 'others' },
  '/',
  { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
  { name: 'paragraph',   groups: [ 'list', 'indent', 'blocks', 'align' ] },
  { name: 'styles' },
  { name: 'colors' }];
  config.width: "100%";
};
