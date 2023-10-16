using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InputManager : MonoBehaviour
{
    private Vector2 touchStartPos;
    private Vector2 touchEndPos;
    public float sensitivity = 1.0f;
    public float horizontalMovement;
    public float verticalMovement;

    void Update()
    {
        if (Input.touchCount > 0)
        {
            Touch touch = Input.GetTouch(0);

            if (touch.phase == TouchPhase.Began)
            {
                touchStartPos = touch.position;
            }
            else if (touch.phase == TouchPhase.Moved)
            {
                touchEndPos = touch.position;
                Vector2 delta = touchEndPos - touchStartPos;

                 horizontalMovement = delta.x * sensitivity;
                 verticalMovement = delta.y * sensitivity;

                // Dokunma verilerini başka bir script'e iletebilirsiniz

                touchStartPos = touchEndPos;
            }
        }
    }
}
