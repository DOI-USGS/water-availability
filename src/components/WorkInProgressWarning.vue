<template>
  <div class="usa-prose">
    <!-- Conditional rendering based on the toggle -->
    <p
      v-if="!featureToggles.showAlternativeWarning && buttonText === 'I understand'"
      class="warning-open"
    >
      <strong>ATTENTION!</strong> You are viewing a prototype application that is in active development.
      Contents seen here are for placeholding and development only. <strong>DO NOT USE</strong> information
      contained in this application for <strong>ANY</strong> purpose.
    </p>
    <p
      v-if="featureToggles.showAlternativeWarning && buttonText === 'I understand'"
      class="warning-open"
    >
      <strong>Welcome!</strong> This is a preview of a website about the upcoming National Water Availability Assessment. It is under active development and may not represent the final version, any content is subject to change.
    </p>
    <button @click="toggleWarning">
      {{ buttonText }}
    </button>
  </div>
</template>


<script setup>
import { ref, inject } from "vue";

// inject feature toggles
const featureToggles = inject('featureToggles');

const buttonText = ref('I understand');

function toggleWarning() {
  buttonText.value =
    buttonText.value === 'I understand'
      ? 'read in progress warning'
      : 'I understand';
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
      background: var(--blue-dark);
      color: #ffffff;
      border: none;
      outline: none;
      padding: 6px 10px;
      border-radius: 5px;
      font-weight: bold;
    }
  }
</style>
