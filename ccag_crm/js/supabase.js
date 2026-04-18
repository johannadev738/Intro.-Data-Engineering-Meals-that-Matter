(function () {
  const SUPABASE_URL =
    window.SUPABASE_URL ||
    "https://icfpyarwxpukjdvsfyjv.supabase.co";

  const SUPABASE_PUBLISHABLE_KEY =
    window.SUPABASE_PUBLISHABLE_KEY ||
    "sb_publishable_K6mUFlfbRlbQHW6Bt23WNQ_btYgLiEu";

  if (!window.supabase) {
    throw new Error("Supabase SDK is not loaded. Add the Supabase script before js/supabase.js.");
  }

  if (!SUPABASE_URL || !SUPABASE_PUBLISHABLE_KEY) {
    throw new Error("Supabase configuration is missing. Define SUPABASE_URL and SUPABASE_PUBLISHABLE_KEY.");
  }

  const client = window.supabase.createClient(SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY, {
    auth: {
      persistSession: true,
      autoRefreshToken: true,
      detectSessionInUrl: true,
    },
  });

  const persistUser = (user) => {
    if (user) {
      localStorage.setItem("user", JSON.stringify(user));
    } else {
      localStorage.removeItem("user");
    }
  };

  async function getSession() {
    const { data, error } = await client.auth.getSession();
    if (error) {
      throw error;
    }
    return data.session || null;
  }

  async function requireAuth(options = {}) {
    const redirectTo = options.redirectTo || "login.html";
    const session = await getSession();

    if (!session) {
      window.location.href = redirectTo;
      return null;
    }

    persistUser(session.user);
    return session.user;
  }

  async function signInWithPassword(email, password) {
    const { data, error } = await client.auth.signInWithPassword({
      email,
      password,
    });

    if (error) {
      throw error;
    }

    persistUser(data.user || null);
    return data;
  }

  async function signUp(email, password) {
    const { data, error } = await client.auth.signUp({
      email,
      password,
    });

    if (error) {
      throw error;
    }

    persistUser(data.user || null);
    return data;
  }

  async function signOut() {
    const { error } = await client.auth.signOut();
    persistUser(null);
    if (error) {
      throw error;
    }
  }

  client.auth.onAuthStateChange((_event, session) => {
    persistUser(session?.user || null);
  });

  window.ccagSupabase = {
    client,
    getSession,
    requireAuth,
    signInWithPassword,
    signUp,
    signOut,
  };

  window.supabaseClient = client;
})();