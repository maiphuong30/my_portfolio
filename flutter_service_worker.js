'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "d7b5f0f1dfcd1a9300e978feabcb2932",
".git/config": "91a40f0919507142a11c6818335af0d8",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/FETCH_HEAD": "960ff87997e48d996e5cbab7d9ac455a",
".git/HEAD": "5ab7a4355e4c959b0c5c008f202f51ec",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "5029bfab85b1c39281aa9697379ea444",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/index": "a5647e7a6ad88ed843a7be8cb91317e6",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "704996e27f10e3c65d63f667fbb69c2a",
".git/logs/refs/heads/gh-pages": "dd5c06882bc9ce29ccc3d04f8d2a3f92",
".git/logs/refs/heads/master": "69d163f5a3eaf417d31820c3b4597dee",
".git/logs/refs/remotes/origin/gh-pages": "6cccbeef43b40c76caae1766abd7824e",
".git/logs/refs/remotes/origin/HEAD": "5067bb9f4df53d29e912e7bc4eebb908",
".git/logs/refs/remotes/origin/main": "afccb0ec95d1f3739864d52a51539581",
".git/objects/02/1d4f3579879a4ac147edbbd8ac2d91e2bc7323": "9e9721befbee4797263ad5370cd904ff",
".git/objects/07/72c96295dba49242cfce07cbab68df22b0a3d5": "669aef70d73b14de1d0fb46029959391",
".git/objects/08/c4f97a6bad27e7c5a0883aa8209d7b7655a03f": "9dc8925d874c0abf37a5d142c70faeb2",
".git/objects/14/328fadd52abc9979344eafccbe7b334e4b19df": "e79f6ea7f0a15ea134b38c18abedb3de",
".git/objects/1d/ef752509c096432802b7c29124e89a46b32eb9": "a5d684ec6e22124144f08df4a423b2b9",
".git/objects/20/3a3ff5cc524ede7e585dff54454bd63a1b0f36": "4b23a88a964550066839c18c1b5c461e",
".git/objects/23/7c5c764760f6919bd6894cf85b803b07bd6ff4": "9d8c259c4184f7c67b8dd30cae18b261",
".git/objects/25/b9262d3547ac9eacb97fbafcd443bff48df8d9": "3e3a0efda1701cda44c5779bf375b209",
".git/objects/27/ac871ceec1b5e5cb8086bab1d12cf4a5d32ef1": "9be7d2d7c866aca2a66d0bfbea1a5fe3",
".git/objects/29/f22f56f0c9903bf90b2a78ef505b36d89a9725": "e85914d97d264694217ae7558d414e81",
".git/objects/2c/9b25a6ab1dd9c7a67605b26d929a43a7f075f4": "ee2d90a79aa24782e185039d2bf9cce9",
".git/objects/31/cc6c7298bf6893debed4c5f048352e99d72358": "20188d28e1c8464624ec2439561e7d5b",
".git/objects/3d/ba9358996721fca6fe726438cb82f2770e4ad0": "16b08b2150bd13ed2b9de8e5fdd8a870",
".git/objects/4d/bf9da7bcce5387354fe394985b98ebae39df43": "534c022f4a0845274cbd61ff6c9c9c33",
".git/objects/4e/b6c27967a4e39045f60fa5b899c60fbfd7437e": "1766052f39913cb8081c33e10af5b85f",
".git/objects/4f/fbe6ec4693664cb4ff395edf3d949bd4607391": "2beb9ca6c799e0ff64e0ad79f9e55e69",
".git/objects/52/896f461139823daf687cc35421b4042e303fbc": "63a42eee682858c78a1735754a5479b4",
".git/objects/5b/5b72391f59b0066e62c10ef316d98a93b1c49a": "c0dd39c449e772dcd030bda8152a95a0",
".git/objects/61/45bc1fe3964155ae274af89685a73784eabdf6": "f48344bc10d0e301a54d9c84e3e83ea0",
".git/objects/62/ebb53f5f8c76342151f3b4df0b803c893db72f": "33df6b2a1405ef02dea09e007135b3e0",
".git/objects/63/1bdca13d22095d95c9e650b0ef4f80719edd52": "e212949464403b380b749f23cab6af82",
".git/objects/66/fc3b84b4cc6f1cce286ac4b55415c9a18d3298": "07f25a5813c13eb8399e341580c24237",
".git/objects/6b/9862a1351012dc0f337c9ee5067ed3dbfbb439": "85896cd5fba127825eb58df13dfac82b",
".git/objects/6c/67535d0ae9b826416f1105b3776a65ea1218c9": "ac46001383c11b848dcb4312716f0fc5",
".git/objects/6d/44c5f9f2eb5682cd037b6998e77199283d43f8": "a39678ae8b12db8787b44d25fb1653d4",
".git/objects/6e/924692537e0bf95f2267d164eb6a2aad9fb77d": "7576c9b1203d5816936038b985948699",
".git/objects/78/631b3b6fc06bac6f6d083617c8d412a29ea299": "d95eb98bc0f26a6ccbff0881fa0dac35",
".git/objects/7a/6c1911dddaea52e2dbffc15e45e428ec9a9915": "f1dee6885dc6f71f357a8e825bda0286",
".git/objects/7f/ab0f9147253097101a3450b3d16614701077ae": "09a2be51b39a775c0af1a854c784db75",
".git/objects/88/85b01c4eb1366b65171d423cf9345fb946e16d": "f6c52d238ddc0da1099ed121ab3732f6",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/89/f076741301961964756ea5ca071dd7ee5d4330": "e5a5a9f9d0345126e3fcd031ea72325e",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/8c/a2655b5001b3e70e3a31c9747c8dea9eb32f47": "adf49d1db42c55a11dc87c69f8d6aa95",
".git/objects/8c/cdf0b768f43a8d078c332000cc9d6ca87e7eec": "5cf38633c5fca6413309097b15cca4e5",
".git/objects/92/67cbff46728745c0f03254029f388916f864cc": "f1b8ce871e7f4557a42800544c3079ac",
".git/objects/98/0d49437042d93ffa850a60d02cef584a35a85c": "8e18e4c1b6c83800103ff097cc222444",
".git/objects/98/2bbd1e95b01d72d736586ae8aa01e736fceac2": "0e9f855b24ad321e3e45df2ad1fcd179",
".git/objects/99/8168df0c0c53ef6ce37ed3e048f1b399bb0e02": "a13cbd2294065ddc746523206ce3b1e9",
".git/objects/9a/e4d08a0b090da52a245d8c2115be3875569684": "78c1f68983d8f68b1910b2350f3a930c",
".git/objects/9b/3ef5f169177a64f91eafe11e52b58c60db3df2": "91d370e4f73d42e0a622f3e44af9e7b1",
".git/objects/9e/2d70e54753da9372ad42a4683864df45d57124": "51ab43057c57a09804108f2f1c096c41",
".git/objects/9e/3b4630b3b8461ff43c272714e00bb47942263e": "accf36d08c0545fa02199021e5902d52",
".git/objects/a9/edeb101761ef2c9c17ba633657e5780f4d39dd": "5c3de5a37dbd051a08a8bd5cef1a7db1",
".git/objects/b2/2106c51c7f09388ea18e5dd67a7cd5188ba2bb": "a71dc80895a4e639faf6ed30db0f01d3",
".git/objects/b6/b8806f5f9d33389d53c2868e6ea1aca7445229": "b14016efdbcda10804235f3a45562bbf",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b8/3ddb62222db552f6180eca1ef1a9f6a5635c06": "73274a7e5a1fabbe792d34ec63fbd1b1",
".git/objects/b9/0efadfd3b29e71449fe720b0d503d3a71e78fc": "1e1acdc2ff3aebde051a6ce6c0c9315c",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/c4/016f7d68c0d70816a0c784867168ffa8f419e1": "fdf8b8a8484741e7a3a558ed9d22f21d",
".git/objects/c4/c21fdde8546224e82d73fe52dac61c4826235f": "5818826be2d2e5c70768248e191eb6b2",
".git/objects/ca/3bba02c77c467ef18cffe2d4c857e003ad6d5d": "316e3d817e75cf7b1fd9b0226c088a43",
".git/objects/cc/fb69081517db6bcad7b72c71cc62d2a39e2e0a": "06b83025ef28d80d3c4a79d38fcb1b30",
".git/objects/d3/1bd163f7e978ed7829ceb4b27093a2295d5115": "cf32793f81bfdd35693c4c9c05393f9e",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/da/72019663491900e07d7ae4c57d6ddd75b5d120": "c51d21f433651654469eb21a98673b8c",
".git/objects/da/f7baf7286b8110fca4788c1e1e041df31fd255": "dcbfc825e3d04840343b7ba0686145cb",
".git/objects/e0/0a73b6be16c2ef4fb6fc982dc09f37cf7f371c": "5ce38e64e1d04398873a514aa733da78",
".git/objects/e2/b5ab7ad5fc1c411a581f44004e929d4c7668d3": "1379bac264973ed2a8c8abeb2af7dd16",
".git/objects/e3/e9ee754c75ae07cc3d19f9b8c1e656cc4946a1": "14066365125dcce5aec8eb1454f0d127",
".git/objects/e5/d179d2a2384134ee4237d01b0ea624a0e0e40e": "17c30cfe646932657905af0b8dd0adb6",
".git/objects/e9/94225c71c957162e2dcc06abe8295e482f93a2": "2eed33506ed70a5848a0b06f5b754f2c",
".git/objects/ea/ba0c5e088000b49012647832aaabe5da3afba3": "ad22838b8bc6a7175af573d164ec20be",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/ed/b55d4deb8363b6afa65df71d1f9fd8c7787f22": "886ebb77561ff26a755e09883903891d",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f5/72b90ef57ee79b82dd846c6871359a7cb10404": "e68f5265f0bb82d792ff536dcb99d803",
".git/objects/f6/b7a14bc63fd6b0dffa3d7cf4ce9e2e97704e8f": "16d9150338bb912837e1cf978ee14c6c",
".git/objects/fc/1e346b463338c2c9887448f23cd100c14f618c": "7354408c51fb3931829d7f000466f4ff",
".git/objects/fe/3b987e61ed346808d9aa023ce3073530ad7426": "dc7db10bf25046b27091222383ede515",
".git/objects/pack/pack-d87839f071a93c9f83df13faed712d250719b3ff.idx": "18e081c755582b2a850d3bfbdc8657c6",
".git/objects/pack/pack-d87839f071a93c9f83df13faed712d250719b3ff.pack": "d1f66fa1ef13f495520307a22b2f6cfe",
".git/objects/pack/pack-d87839f071a93c9f83df13faed712d250719b3ff.rev": "f744b6a614e2e097114591fa204892ea",
".git/ORIG_HEAD": "74b7314c773d84f56f3f341d1a457a72",
".git/refs/heads/gh-pages": "05c3d2873050ebb03fbfd99685b573fb",
".git/refs/heads/master": "cef443f6a792cb5f077a87de81070b21",
".git/refs/remotes/origin/gh-pages": "05c3d2873050ebb03fbfd99685b573fb",
".git/refs/remotes/origin/HEAD": "98b16e0b650190870f1b40bc8f4aec4e",
".git/refs/remotes/origin/main": "b94be7b07ef6ed440ecc7f7f6797119a",
"assets/AssetManifest.bin": "1e697d514071771adbc56bc2d0fec2aa",
"assets/AssetManifest.bin.json": "b3da230b66636f1ec57f77ca522c6e02",
"assets/AssetManifest.json": "95e2add0878017dca7afaf37cf090390",
"assets/assets/images/IMG_MYPHOTO.jpg": "cea659b7525de0b3a28668b13dd1285c",
"assets/assets/images/testImg.png": "f09d91e59d1088dcae621e074a228c90",
"assets/FontManifest.json": "97c2528ecc2fbf4093965257fdba1854",
"assets/fonts/MaterialIcons-Regular.otf": "f595503c1e9b8d02e8ac3eef0a5f1d60",
"assets/NOTICES": "b5b93cd6a79c82faa90b749bde93e310",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/font_awesome_flutter/lib/fonts/Font%2520Awesome%25207%2520Brands-Regular-400.otf": "ebfcf74fc4613ae8f0432ced2d4052c7",
"assets/packages/font_awesome_flutter/lib/fonts/Font%2520Awesome%25207%2520Free-Regular-400.otf": "f6723c8d8cbea175047a1dc2294a4de5",
"assets/packages/font_awesome_flutter/lib/fonts/Font%2520Awesome%25207%2520Free-Solid-900.otf": "e605bf4df3a9e4cb0803f333f4e0809d",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "ffb27ae3ad7914508b125dc213f2f810",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "bf1e45747974a42ebcf850f57cc46223",
"/": "bf1e45747974a42ebcf850f57cc46223",
"main.dart.js": "b0f3abb394e47b978356ea25f8a0f1cc",
"manifest.json": "d8fe34f7ae4c072a77b924e01dac8a50",
"version.json": "9b818ca9511483c901bed1545384376c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
