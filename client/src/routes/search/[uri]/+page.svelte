<script lang="ts">
  import { Search } from "lucide-svelte";
  import Error from "$lib/Error.svelte";
	import Logo from "$lib/Logo.svelte";
	import api from "$lib/api.js";

  export let data;
  
  let queryInput: string = "";
  let queryInputError: string | null = null;
  let showError = false;

  const validateQueryInput = (queryInput: string) => {
    if (!queryInput.length) {
      queryInputError = "You should write a search query first."
    }

    return queryInput;
  };

  let searchPromise: undefined | Promise<any>;

  const search = () => {
    showError = false;
    const query = validateQueryInput(queryInput);

    if (!query) { showError = true; return; }
  
    const payload = {
      uri: data.uri,
      query
    };

    searchPromise = api.search(payload);
  };
</script>

<div class="w-full h-screen flex flex-col justify-center items-center container mx-auto px-4 sm:px-6 lg:px-36 dark:text-indigo-100">
  <div class="text-4xl sm:text-6xl">
    <Logo />
  </div>

  <div class="flex flex-wrap justify-center mt-6 gap-x-8 gap-y-4 col-auto">
    <div class="relative flex items-center w-80">
      <input 
        bind:value={queryInput}
        type="url"
        placeholder="Search query..."
        class="peer input-shadow dark:bg-stone-950 rounded-full placeholder:text-zinc-400 text-zinc-700 dark:text-indigo-100 w-full px-3 py-1.5 pl-12 text-lg outline-indigo-300"
      />
      <Error error={queryInputError} show={showError} />
      <Search class="mx-3 absolute left-0 text-zinc-400 peer-focus:text-indigo-500" />
    </div>

    <div class="flex justify-center items-center w-auto">
      <button
        on:click={search}
        class="block px-4 py-2 rounded-full font-chubbo font-semibold transition"
        class:active-index={queryInput.length} 
        class:inactive-index={!queryInput.length}
      >
        Search
      </button>
    </div>
  </div>

  {#await searchPromise}
    ayyyy
  {:then data}
    successuflly fetched content
  {:catch error}
    {error}
  {/await}
</div>

<style>
  .active-index {
    @apply bg-indigo-500 dark:bg-indigo-800/40 ;
    @apply text-indigo-50 dark:text-indigo-300/80;
  }

  .inactive-index {
    @apply bg-indigo-200 dark:bg-indigo-600;
    @apply text-indigo-50
  }

  .input-shadow {
    box-shadow: 0px 9px 30px rgba(35, 65, 210, 0.1);
  }

	@media screen and (prefers-color-scheme: dark) {
    .input-shadow {
      box-shadow: 0px 9px 45px rgba(30, 30, 180, 0.17);
    }
	}
</style>
