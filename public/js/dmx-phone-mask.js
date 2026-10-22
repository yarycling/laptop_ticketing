dmx.Component('phone-mask', {
  attributes: {
    mask: {
      type: String,
      default: '(999)999-9999'
    }
  },

  render(node) {
    this.$node = node;
    this._applyMask();
  },

  performUpdate(updatedProps) {
    if (updatedProps.has('mask')) {
      this._applyMask();
    }
  },

  destroy() {
    if (this._inputMask) {
      this._inputMask.remove();
      this._inputMask = null;
    }
  },

  _applyMask() {
    if (this._inputMask) {
      this._inputMask.remove();
    }

    this._inputMask = new Inputmask({
      mask: this.props.mask,
      jitMasking: true,
      showMaskOnHover: false,
      showMaskOnFocus: false,
      placeholder: '',
      clearIncomplete: false,
      autoUnmask: false,
      removeMaskOnSubmit: false
    }).mask(this.$node);
  }
});
