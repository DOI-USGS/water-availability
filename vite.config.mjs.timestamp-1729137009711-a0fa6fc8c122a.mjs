// vite.config.mjs
import { fileURLToPath, URL } from "node:url";
import { defineConfig, loadEnv } from "file:///Users/cnell/Documents/Projects/water-availability/node_modules/vite/dist/node/index.js";
import vue from "file:///Users/cnell/Documents/Projects/water-availability/node_modules/@vitejs/plugin-vue/dist/index.mjs";
import { ViteEjsPlugin } from "file:///Users/cnell/Documents/Projects/water-availability/node_modules/vite-plugin-ejs/index.js";
import svgLoader from "file:///Users/cnell/Documents/Projects/water-availability/node_modules/vite-svg-loader/index.js";
var __vite_injected_original_import_meta_url = "file:///Users/cnell/Documents/Projects/water-availability/vite.config.mjs";
var vite_config_default = ({ mode }) => {
  process.env = { ...process.env, ...loadEnv(mode, process.cwd()) };
  return defineConfig({
    publicPath: "./",
    outputDir: "dist",
    assetsDir: "static",
    plugins: [
      vue(),
      ViteEjsPlugin({
        VITE_APP_TIER: process.env.VITE_APP_TIER
      }),
      svgLoader({
        svgo: false
      })
    ],
    resolve: {
      alias: {
        "@": fileURLToPath(new URL("./src", __vite_injected_original_import_meta_url))
      }
    },
    base: `/visualizations/${process.env.VITE_APP_TITLE}/`
  });
};
export {
  vite_config_default as default
};
//# sourceMappingURL=data:application/json;base64,ewogICJ2ZXJzaW9uIjogMywKICAic291cmNlcyI6IFsidml0ZS5jb25maWcubWpzIl0sCiAgInNvdXJjZXNDb250ZW50IjogWyJjb25zdCBfX3ZpdGVfaW5qZWN0ZWRfb3JpZ2luYWxfZGlybmFtZSA9IFwiL1VzZXJzL2NuZWxsL0RvY3VtZW50cy9Qcm9qZWN0cy93YXRlci1hdmFpbGFiaWxpdHlcIjtjb25zdCBfX3ZpdGVfaW5qZWN0ZWRfb3JpZ2luYWxfZmlsZW5hbWUgPSBcIi9Vc2Vycy9jbmVsbC9Eb2N1bWVudHMvUHJvamVjdHMvd2F0ZXItYXZhaWxhYmlsaXR5L3ZpdGUuY29uZmlnLm1qc1wiO2NvbnN0IF9fdml0ZV9pbmplY3RlZF9vcmlnaW5hbF9pbXBvcnRfbWV0YV91cmwgPSBcImZpbGU6Ly8vVXNlcnMvY25lbGwvRG9jdW1lbnRzL1Byb2plY3RzL3dhdGVyLWF2YWlsYWJpbGl0eS92aXRlLmNvbmZpZy5tanNcIjtpbXBvcnQgeyBmaWxlVVJMVG9QYXRoLCBVUkwgfSBmcm9tICdub2RlOnVybCdcblxuLy8gaW1wb3J0IHJlcGxhY2UgZnJvbSBcIkByb2xsdXAvcGx1Z2luLXJlcGxhY2VcIjtcbmltcG9ydCB7IGRlZmluZUNvbmZpZywgbG9hZEVudiB9IGZyb20gJ3ZpdGUnO1xuaW1wb3J0IHZ1ZSBmcm9tICdAdml0ZWpzL3BsdWdpbi12dWUnO1xuaW1wb3J0IHtWaXRlRWpzUGx1Z2lufSBmcm9tIFwidml0ZS1wbHVnaW4tZWpzXCI7XG5pbXBvcnQgc3ZnTG9hZGVyIGZyb20gJ3ZpdGUtc3ZnLWxvYWRlcidcblxuLy8gaHR0cHM6Ly92aXRlanMuZGV2L2NvbmZpZy9cbmV4cG9ydCBkZWZhdWx0ICh7bW9kZX0pID0+IHtcblxuICBwcm9jZXNzLmVudiA9IHsuLi5wcm9jZXNzLmVudiwgLi4ubG9hZEVudihtb2RlLCBwcm9jZXNzLmN3ZCgpKX07XG5cbiAgcmV0dXJuIGRlZmluZUNvbmZpZyh7XG4gICAgcHVibGljUGF0aDogXCIuL1wiLFxuICAgIG91dHB1dERpcjogXCJkaXN0XCIsXG4gICAgYXNzZXRzRGlyOiBcInN0YXRpY1wiLFxuICAgIHBsdWdpbnM6IFtcbiAgICAgIHZ1ZSgpLCBcbiAgICAgIFZpdGVFanNQbHVnaW4oe1xuICAgICAgICBWSVRFX0FQUF9USUVSOiBwcm9jZXNzLmVudi5WSVRFX0FQUF9USUVSXG4gICAgICB9KSxcbiAgICAgIHN2Z0xvYWRlcih7XG4gICAgICAgIHN2Z286IGZhbHNlXG4gICAgICB9KVxuICAgIF0sXG4gICAgcmVzb2x2ZToge1xuICAgICAgYWxpYXM6IHtcbiAgICAgICAgJ0AnOiBmaWxlVVJMVG9QYXRoKG5ldyBVUkwoJy4vc3JjJywgaW1wb3J0Lm1ldGEudXJsKSksXG4gICAgICB9XG4gICAgfSxcbiAgICBiYXNlOiBgL3Zpc3VhbGl6YXRpb25zLyR7cHJvY2Vzcy5lbnYuVklURV9BUFBfVElUTEV9L2BcbiAgfSk7XG59XG4iXSwKICAibWFwcGluZ3MiOiAiO0FBQTBVLFNBQVMsZUFBZSxXQUFXO0FBRzdXLFNBQVMsY0FBYyxlQUFlO0FBQ3RDLE9BQU8sU0FBUztBQUNoQixTQUFRLHFCQUFvQjtBQUM1QixPQUFPLGVBQWU7QUFOdUwsSUFBTSwyQ0FBMkM7QUFTOVAsSUFBTyxzQkFBUSxDQUFDLEVBQUMsS0FBSSxNQUFNO0FBRXpCLFVBQVEsTUFBTSxFQUFDLEdBQUcsUUFBUSxLQUFLLEdBQUcsUUFBUSxNQUFNLFFBQVEsSUFBSSxDQUFDLEVBQUM7QUFFOUQsU0FBTyxhQUFhO0FBQUEsSUFDbEIsWUFBWTtBQUFBLElBQ1osV0FBVztBQUFBLElBQ1gsV0FBVztBQUFBLElBQ1gsU0FBUztBQUFBLE1BQ1AsSUFBSTtBQUFBLE1BQ0osY0FBYztBQUFBLFFBQ1osZUFBZSxRQUFRLElBQUk7QUFBQSxNQUM3QixDQUFDO0FBQUEsTUFDRCxVQUFVO0FBQUEsUUFDUixNQUFNO0FBQUEsTUFDUixDQUFDO0FBQUEsSUFDSDtBQUFBLElBQ0EsU0FBUztBQUFBLE1BQ1AsT0FBTztBQUFBLFFBQ0wsS0FBSyxjQUFjLElBQUksSUFBSSxTQUFTLHdDQUFlLENBQUM7QUFBQSxNQUN0RDtBQUFBLElBQ0Y7QUFBQSxJQUNBLE1BQU0sbUJBQW1CLFFBQVEsSUFBSSxjQUFjO0FBQUEsRUFDckQsQ0FBQztBQUNIOyIsCiAgIm5hbWVzIjogW10KfQo=
