UI
##

Injecting Buttons
*****************

.. code-block:: php

    <?php
    // plugins/HelloWorldBundle/Event/ButtonSubscriber.php

    namespace MauticPlugin\HelloWorldBundle\EventListener;


    use Mautic\CoreBundle\CoreEvents;
    use Mautic\CoreBundle\Event\CustomButtonEvent;
    use Mautic\CoreBundle\EventListener\CommonSubscriber;
    use Mautic\CoreBundle\Templating\Helper\ButtonHelper;
    use Mautic\LeadBundle\Entity\Lead;

    class ButtonSubscriber extends CommonSubscriber
    {
        public static function getSubscribedEvents()
        {
            return [
                CoreEvents::VIEW_INJECT_CUSTOM_BUTTONS => ['injectViewButtons', 0]
            ];
        }

        /**
         * @param CustomButtonEvent $event
         */
        public function injectViewButtons(CustomButtonEvent $event)
        {
            // Injects a button into the toolbar area for any page with a high priority (displays closer to first)
            $event->addButton(
                [
                    'attr'      => [
                        'class'       => 'btn btn-default btn-sm btn-nospin',
                        'data-toggle' => 'ajaxmodal',
                        'data-target' => '#MauticSharedModal',
                        'href'        => $this->router->generate('mautic_world_action', ['objectAction' => 'doSomething']),
                        'data-header' => 'Extra Button',
                    ],
                    'tooltip'   => $this->translator->trans('mautic.world.dosomething.btn.tooltip'),
                    'iconClass' => 'fa fa-star',
                    'priority'  => 255,
                ],
                ButtonHelper::LOCATION_TOOLBAR_ACTIONS
            );

            //
            if ($lead = $event->getItem()) {
                if ($lead instanceof Lead) {
                    $sendEmailButton = [
                        'attr'      => [
                            'data-toggle' => 'ajaxmodal',
                            'data-target' => '#MauticSharedModal',
                            'data-header' => $this->translator->trans(
                                'mautic.world.dosomething.header',
                                ['%email%' => $event->getItem()->getEmail()]
                            ),
                            'href'        => $this->router->generate(
                                'mautic_world_action',
                                ['objectId' => $event->getItem()->getId(), 'objectAction' => 'doSomething']
                            ),
                        ],
                        'btnText'   => 'Extra Button',
                        'iconClass' => 'fa fa-star',
                        'primary'   => true,
                        'priority'  => 255,
                    ];

                    // Inject a button into the page actions for the specified route (in this case /s/contacts/view/{contactId})
                    $event
                        ->addButton(
                            $sendEmailButton,
                            // Location of where to inject the button; this can be an array of multiple locations
                            ButtonHelper::LOCATION_PAGE_ACTIONS,
                            ['mautic_contact_action', ['objectAction' => 'view']]
                        )
                        // Inject a button into the list actions for each contact on the /s/contacts page
                        ->addButton(
                            $sendEmailButton,
                            ButtonHelper::LOCATION_LIST_ACTIONS,
                            'mautic_contact_index'
                        );
                }
            }
        }
    }

As of Mautic 2.3.0, support for plugins to inject buttons throughout Mautic's UI has been added by listening to the `CoreEvents::VIEW_INJECT_CUSTOM_BUTTONS` event.

There are five places in Mautic's UI that buttons can be injected into:

.. list-table::
    :header-rows: 1

    *   - Location
        - Description
    *   - ``\Mautic\CoreBundle\Templating\Helper\ButtonHelper::LOCATION_LIST_ACTIONS``
        - Drop down actions per each item in list views.
    *   - ``\Mautic\CoreBundle\Templating\Helper\ButtonHelper::LOCATION_TOOLBAR_ACTIONS``
        - Top right above list view tables to the right of the table filter. Preferably buttons with icons only.
    *   - ``\Mautic\CoreBundle\Templating\Helper\ButtonHelper::LOCATION_PAGE_ACTIONS``
        - Main page buttons to the right of the page title (New, Edit, etc). Primary buttons will be displayed as buttons while the rest will be displayed in a drop down.
    *   - ``\Mautic\CoreBundle\Templating\Helper\ButtonHelper::LOCATION_NAVBAR``
        - Top of the page to the left of the account/profile menu. Buttons with text and/or icons.
    *   - ``\Mautic\CoreBundle\Templating\Helper\ButtonHelper::LOCATION_BULK_ACTIONS``
        - Buttons inside the bulk dropdown (around the checkall checkbox of lists).

Buttons use a priority system to determine order. The higher the priority, the closer to first the button is displayed. The lower the priority, the closer to last. For a button dropdown, setting a button as `primary` will display the button in the button group rather than the dropdown.

Button Array Format
===================

The array defining the button can include the following keys:

.. list-table::
    :header-rows: 1

    *   - Key
        - Type
        - Description
    *   - attr
        - array
        - Array of attributes to be appended to the button (data attributes, href, etc)
    *   - btnText
        - string
        - Text to display for the button
    *   - iconClass
        - string
        - Font Awesome class to use as the icon within the button
    *   - tooltip
        - string
        - Text to display as a tooltip
    *   - primary
        - boolean
        - For button dropdown formats, this will display the button in the group rather than in the dropdown
    *   - priority
        - int
        - Determines the order of buttons. Higher the priority, closer to the first the button will be placed. Buttons with the same priority wil be ordered alphabetically.

If a button is to display a confirmation modal, the key `confirm` can be used. A `confirm` array  can have the following keys:

.. list-table::
    :header-rows: 1

    *   - Key
        - Type
        - Description
    *   - message
        - string
        - Translated message to display in the confirmation window
    *   - confirmText
        - string
        - Text to display as the confirm button
    *   - confirmAction
        - string
        - HREF of the button
    *   - cancelText
        - string
        - Text to display as the cancel button
    *   - cancelCallback
        - string
        - Mautic namespaced Javascript method to be executed when the cancel button is clicked
    *   - confirmCallback
        - string
        - Mautic namespaced Javascript method to be executed when the confirm button is clicked
    *   - precheck
        - string
        - Mautic namespaced Javascript method to be executed prior to displaying the confirmation modal
    *   - btnClass
        - string
        - Class for the button
    *   - iconClass
        - string
        - Font Awesome class to use as the icon
    *   - btnTextAttr
        - string
        - string of attributes to append to the button's inner text
    *   - attr
        - array
        - Array of attributes to append to the button's outer tag
    *   - tooltip
        - string
        - Translated string to display as a tooltip
    *   - tag
        - string
        - Tag to use as the button. Defaults to an `a` tag.
    *   - wrapOpeningTag
        - string
        - Tag/html to wrap button in. Defaults to nothing.
    *   - wrapClosingTag
        - string
        - Tag/thml to close wrapOpeningTag. Defaults to nothing.

On the same nested level as the `confirm` key can include `primary` and/or `priority`.

Defining Button Locations
=========================

.. code-block:: php

    <?php
    $dropdownOpenHtml = '<button type="button" class="btn btn-default btn-nospin  dropdown-toggle" data-toggle="dropdown" aria-expanded="false"><i class="fa fa-caret-down"></i></button>'
              ."\n";
    $dropdownOpenHtml .= '<ul class="dropdown-menu dropdown-menu-right" role="menu">'."\n";

    echo $view['buttons']->reset($app->getRequest(), 'custom_location')->renderButtons($dropdownOpenHtml, '</ul>');


A plugin can define it's own locations that other plugins can leverage by using the template `buttons` helper.

There are three types of button groups supported:

.. list-table::
    :header-rows: 1

    *   - Type
        - Description
    *   - \Mautic\CoreBundle\Templating\Helper\ButtonHelper::TYPE_BUTTON_DROPDOWN
        - Primary buttons are displayed in a button group while others in a dropdown menu.
    *   - \Mautic\CoreBundle\Templating\Helper\ButtonHelper::TYPE_DROPDOWN
        - Buttons displayed in a dropdown menu.
    *   - \Mautic\CoreBundle\Templating\Helper\ButtonHelper::TYPE_GROUP
        - A group of buttons side by side.

Dropdowns require the wrapping HTML to be passed to the `renderButtons` method.
