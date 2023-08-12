import { IconProp } from '@fortawesome/fontawesome-svg-core';

export interface IInput {
  type: 'input';
  label: string;
  placeholder?: string;
  default?: string;
  password?: boolean;
  icon?: IconProp;
  disabled?: boolean;
  description?: string;
}

export interface ICheckbox {
  type: 'checkbox';
  label: string;
  checked?: boolean;
  disabled?: boolean;
  description?: string;
}

export interface ISelect {
  type: 'select';
  label: string;
  default?: string;
  options?: { value: string; label?: string }[];
  disabled?: boolean;
  description?: string;
}

export interface INumber {
  type: 'number';
  label: string;
  placeholder?: string;
  default?: number;
  icon?: IconProp;
  min?: number;
  max?: number;
  disabled?: boolean;
  description?: string;
}

export interface ISlider {
  type: 'slider';
  label: string;
  default?: number;
  min?: number;
  max?: number;
  step?: number;
  disabled?: boolean;
  description?: string;
}
