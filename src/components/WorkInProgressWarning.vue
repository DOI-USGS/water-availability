<template>
  <div class="usa-prose">
    <p
      v-if="buttonText === 'I understand'"
      class="warning-open"
    >
      <strong>ATTENTION!</strong> You are viewing a prototype application that is in active development.
      Contents seen here are for placeholding and development only. <strong>DO NOT USE</strong> information
      contained in this application for <strong>ANY</strong> purpose.
    </p>
    <button @click="toggleWarning">
      {{ buttonText }}
    </button>
  </div>
</template>

<script setup>
  import { ref } from "vue";

  const buttonText = ref();
  buttonText.value = 'I understand';

  function toggleWarning() {
    buttonText.value === 'I understand' ? buttonText.value = 'read in progress warning' : buttonText.value = 'I understand';
  }
</script>

<style scoped lang="scss">
  .usa-prose {
    background-color: var(--teal-dark);
    padding-bottom: 0.3em;
    padding-top: 0.3em;
    p {
    max-width: 50em;
    text-align: center;
    margin: 0 auto 5px auto;
    color: white;
    }
    button {
      display: block;
      margin: 0 auto;
      background: var(--color-USGS-header-footer);
      color: #ffffff;
      border: none;
      outline: none;
      padding: 6px 10px;
      border-radius: 5px;
      font-weight: bold;
    }
  }
</style>
