#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include "lvgl/lvgl.h"

/* Screen width and height */
uint16_t window_width = 800;
uint16_t window_height = 480;

/* Slider event handler */
static void slider_event_cb(lv_event_t *e)
{
    lv_obj_t *slider = lv_event_get_target(e); // Get the slider
    int value = lv_slider_get_value(slider);   // Get the slider's current value

    /* Update label with slider value */
    lv_obj_t *label = lv_event_get_user_data(e); // Get the label passed as user data
    lv_label_set_text_fmt(label, "Value: %d", value);
}

int main(void)
{
    /* Initialize LVGL */
    lv_init();

    /* Create an SDL2 window */
    lv_sdl_window_create(window_width, window_height);

    /* Create a slider */
    lv_obj_t *slider = lv_slider_create(lv_scr_act()); // Create a slider on the active screen
    lv_slider_set_range(slider, 0, 100);              // Set range from 0 to 100
    lv_obj_align(slider, LV_ALIGN_CENTER, 0, 0);      // Center the slider

    /* Create a label to display the slider value */
    lv_obj_t *label = lv_label_create(lv_scr_act()); // Create a label on the active screen
    lv_label_set_text(label, "Value: 50");          // Initial value
    lv_obj_align_to(label, slider, LV_ALIGN_OUT_TOP_MID, 0, -10); // Place label above slider

    /* Attach the event callback to the slider */
    lv_obj_add_event_cb(slider, slider_event_cb, LV_EVENT_VALUE_CHANGED, label);

    /* Run the LVGL loop */
    while (1) {
        lv_timer_handler(); // Handle LVGL tasks
        usleep(5 * 1000);   // Sleep for 5ms
    }

    return 0;
}
